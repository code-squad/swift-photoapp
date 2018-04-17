//
//  PhotoService.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 17..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Photos

class PhotoService: NSObject, PHPhotoLibraryChangeObserver {
    var delegate: UpdateCollectionViewDelegate?
    private let imageManager: PHCachingImageManager
    private var photos: Photos

    override init() {
        self.imageManager = PHCachingImageManager()
        self.photos = Photos()
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    var count: Int {
        return self.photos.photoAssets.count
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.photos.photoAssets) else { return }
        self.photos.updateAssets(with: changes.fetchResultAfterChanges)
        DispatchQueue.main.async {
            self.delegate?.updateCollectionView(changes)
        }
    }

    func requestImage(at index: Int, _ completion: @escaping (UIImage?) -> (Void)) {
        imageManager.requestImage(for: photos.at(index),
                                  targetSize: CGSize(width: ViewConfig.itemWidth, height: ViewConfig.itemHeight),
                                  contentMode: PHImageContentMode.aspectFill,
                                  options: nil) { image, _ in completion(image) }
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}
