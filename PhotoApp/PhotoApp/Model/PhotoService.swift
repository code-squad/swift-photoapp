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

    init(photos: Photos) {
        self.imageManager = PHCachingImageManager()
        self.photos = photos
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
                                  targetSize: CGSize(width: 100, height: 100),
                                  contentMode: .aspectFill,
                                  options: nil) { image, _ in completion(image) }
    }

}
