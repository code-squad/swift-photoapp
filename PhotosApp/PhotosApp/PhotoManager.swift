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
