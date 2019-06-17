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

class PhotoManager {
    private var photoAssets = PHAsset.fetchAssets(with: nil)
    private let imageManager = PHCachingImageManager()
    private let thumbnailSize = CGSize(width: Configuration.Image.width,
                                       height: Configuration.Image.height)
    
    func register(observer: PHPhotoLibraryChangeObserver) {
        PHPhotoLibrary.shared().register(observer)
    }
    
    func assets() -> PHFetchResult<PHAsset> {
        return photoAssets
    }
    
    func change(assets: PHFetchResult<PHAsset>) {
        photoAssets = assets
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
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: self.photoManager.assets()) else { return }
        self.photoManager.change(assets: changes.fetchResultAfterChanges)
        
        DispatchQueue.main.async {
            if changes.hasIncrementalChanges {
                self.update(collectionView: self.photosCollectionView,
                            with: changes)
            } else {
                self.photosCollectionView.reloadData()
            }
        }
    }
    
    private func update(collectionView: UICollectionView, with changes: PHFetchResultChangeDetails<PHAsset>) {
        collectionView.performBatchUpdates({
            if let removed = changes.removedIndexes, removed.count > 0 {
                collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section: 0)})
            }
            if let inserted = changes.insertedIndexes, inserted.count > 0 {
                collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
            }
            if let changed = changes.changedIndexes, changed.count > 0 {
                collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
            }
            changes.enumerateMoves { fromIndex, toIndex in
                collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                        to: IndexPath(item: toIndex, section: 0))
            }
        })
    }
}
