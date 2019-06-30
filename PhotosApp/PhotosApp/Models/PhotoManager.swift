//
//  PhotoManager.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 17..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation
import Photos
import PhotosUI

class PhotoManager: NSObject {
    private var photoAssets = PHAsset.fetchAssets(with: nil)
    private let imageManager = PHCachingImageManager()
    private let thumbnailSize = CGSize(width: Configuration.Image.width,
                                       height: Configuration.Image.height)
    private let ciContext = CIContext()
    private let formatIdentifier = Bundle.main.bundleIdentifier!
    private let formatVersion = "1.0"
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    func count() -> Int {
        return photoAssets.count
    }
    
    func requestImage(with item: Int, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        let photoAsset = photoAssets.object(at: item)
        imageManager.requestImage(for: photoAsset,
                                  targetSize: thumbnailSize,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: completion)
    }
    
    func startCachingImages(for indexPaths: [IndexPath]) {
        let assets = indexPaths.map { photoAssets.object(at: $0.item) }
        imageManager.startCachingImages(for: assets,
                                        targetSize: thumbnailSize,
                                        contentMode: .aspectFill,
                                        options: nil)
    }
    
    func stopCachingImages(for indexPaths: [IndexPath]) {
        let assets = indexPaths.map { photoAssets.object(at: $0.item) }
        imageManager.stopCachingImages(for: assets,
                                        targetSize: thumbnailSize,
                                        contentMode: .aspectFill,
                                        options: nil)
    }
    
    func livePhotoImage(for item: Int) -> UIImage? {
        let asset = photoAssets.object(at: item)
        guard asset.mediaSubtypes == .photoLive else { return  nil }
        return PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
    }
    
    func images(for indexPaths: [IndexPath], size: CGSize) -> [UIImage] {
        var images = [UIImage]()
        for indexPath in indexPaths {
            let asset = photoAssets.object(at: indexPath.item)
            let manager = PHImageManager()
            let option = PHImageRequestOptions()
            option.resizeMode = .exact
            option.deliveryMode = .opportunistic
            manager.requestImage(for: asset,
                                 targetSize: size,
                                 contentMode: .aspectFill,
                                 options: option) { (image, _) in
                                    guard let image = image else { return }
                                    images.append(image)
            }
        }
        return images
    }
    
    func applyFilter(to indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            applyFilter(to: indexPath)
        }
    }
    
    private func applyFilter(to indexPath: IndexPath) {
        let asset = photoAssets.object(at: indexPath.item)
        asset.requestContentEditingInput(with: nil) { (input, _) in
            guard let input = input else { return }
            let filterName = "CIBloom"
            DispatchQueue.global().async {
                guard let data = filterName.data(using: .utf8) else { return }
                let adjustmentData = PHAdjustmentData(formatIdentifier: self.formatIdentifier,
                                                      formatVersion: self.formatVersion,
                                                      data: data)
                let output = PHContentEditingOutput(contentEditingInput: input)
                output.adjustmentData = adjustmentData

                let completion = { () -> Void in
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetChangeRequest(for: asset)
                        request.contentEditingOutput = output
                    })
                }
                
                if asset.mediaSubtypes.contains(.photoLive) {
                    self.applyLivePhotoFilter(filterName, input: input, output: output, completion: completion)
                } else if asset.mediaType == .image {
                    self.applyPhotoFilter(filterName, input: input, output: output, completion: completion)
                } else if asset.mediaType == .video {
                    self.applyVideoFilter(filterName, input: input, output: output, completion: completion)
                }
            }
        }
    }
    
    private func applyPhotoFilter(_ filterName: String, input: PHContentEditingInput, output: PHContentEditingOutput, completion: () -> Void) {
        guard let url = input.fullSizeImageURL,
            let inputImage = CIImage(contentsOf: url) else { return }
        let outputImage = inputImage.applyingFilter(filterName, parameters: [:])
        guard let colorSpace = inputImage.colorSpace else { return }
        try? self.ciContext.writeJPEGRepresentation(of: outputImage,
                                                    to: output.renderedContentURL,
                                                    colorSpace: colorSpace)
        completion()
    }
    
    private func applyLivePhotoFilter(_ filterName: String, input: PHContentEditingInput, output: PHContentEditingOutput, completion: @escaping () -> Void) {
        guard let livePhotoContext = PHLivePhotoEditingContext(livePhotoEditingInput: input) else { return }
        livePhotoContext.frameProcessor = { frame, _ in
            return frame.image.applyingFilter(filterName, parameters: [:])
        }
        livePhotoContext.saveLivePhoto(to: output) { success, error in
            guard success else { return }
            completion()
        }
    }
    
    private func applyVideoFilter(_ filterName: String, input: PHContentEditingInput, output: PHContentEditingOutput, completion: @escaping () -> Void) {
        guard let avAsset = input.audiovisualAsset else { return }
        
        let composition = AVVideoComposition(asset: avAsset) { (request) in
            let filtered = request.sourceImage.applyingFilter(filterName, parameters: [:])
            request.finish(with: filtered, context: nil)
        }

        guard let export = AVAssetExportSession(asset: avAsset,
                                                presetName: AVAssetExportPresetHighestQuality) else { return }
        export.outputFileType = AVFileType.mov
        export.outputURL = output.renderedContentURL
        export.videoComposition = composition
        export.exportAsynchronously(completionHandler: completion)
    }
    
    func revert(by indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            revert(by: indexPath)
        }
    }
    
    private func revert(by indexPath: IndexPath) {
        let asset = photoAssets.object(at: indexPath.item)
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: asset)
            request.revertAssetContentToOriginal()
        })
    }
    
    func isModified(_ indexPath: IndexPath) -> Bool {
        let asset = photoAssets.object(at: indexPath.item)
        let resources = PHAssetResource.assetResources(for: asset).filter { $0.type == .adjustmentData }
        return resources.count > 0
    }
}

extension PhotoManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: photoAssets) else { return }
        photoAssets = changes.fetchResultAfterChanges
        if changes.hasIncrementalChanges {
            self.update(with: changes)
        } else {
            NotificationCenter.default.post(name: .notIncrementalChanges,
                                            object: self)
        }
    }
    
    private func update(with changes: PHFetchResultChangeDetails<PHAsset>) {
        if let removed = changes.removedIndexes, removed.count > 0 {
            let paths = removed.map { IndexPath(item: $0, section: 0)}
            let userInfo = [UserInfoKey.removedPaths: paths]
            NotificationCenter.default.post(name: .photoDidDeleted,
                                            object: self,
                                            userInfo: userInfo)
        }
        if let inserted = changes.insertedIndexes, inserted.count > 0 {
            let paths = inserted.map { IndexPath(item: $0, section: 0)}
            let userInfo = [UserInfoKey.insertedPaths: paths]
            NotificationCenter.default.post(name: .photoDidInserted,
                                            object: self,
                                            userInfo: userInfo)
        }
        if let changed = changes.changedIndexes, changed.count > 0 {
            let paths = changed.map { IndexPath(item: $0, section: 0)}
            let userInfo = [UserInfoKey.changedPaths: paths]
            NotificationCenter.default.post(name: .photoDidChanged,
                                            object: self,
                                            userInfo: userInfo)
        }
        
        changes.enumerateMoves { fromIndex, toIndex in
            let userInfo = [UserInfoKey.movedPaths: (fromIndex, toIndex)]
            NotificationCenter.default.post(name: .photoDidMoved,
                                            object: self,
                                            userInfo: userInfo)
        }
    }
}

extension NSNotification.Name {
    static let photoDidDeleted = NSNotification.Name("photoDidDeleted")
    static let photoDidInserted = NSNotification.Name("photoDidInserted")
    static let photoDidChanged = NSNotification.Name("photoDidChanged")
    static let photoDidMoved = NSNotification.Name("photoDidMoved")
    static let notIncrementalChanges = NSNotification.Name("notIncrementalChanges")
}
