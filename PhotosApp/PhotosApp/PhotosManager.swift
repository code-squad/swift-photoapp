//
//  PhotosManager.swift
//  PhotosApp
//
//  Created by TaeHyeonLee on 2018. 5. 25..
//  Copyright © 2018년 ChocOZerO. All rights reserved.
//

import Foundation
import Photos

class PhotosManager {
    private let imageManager = PHCachingImageManager()
    private var fetchResult: PHFetchResult<PHAsset>!
    private let thumbnailSize = CGSize(width: 100, height: 100)
    private var previousPreheatRect = CGRect.zero

    var fetchResultCount: Int {
        return fetchResult.count
    }

    init() {
        setFetchResult()
        resetCachedAssets()
    }
    
    private func setFetchResult() {
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }

    func localIdentifier(at index: Int) -> String {
        return  fetchResult.object(at: index).localIdentifier
    }

    func requestImage(at index: Int, completion: @escaping (UIImage?) -> ()) {
        let asset = fetchResult.object(at: index)
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil,
                                  resultHandler: { image, _ in
                                    completion(image)
        })
    }

    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) -> PHFetchResultChangeDetails<PHAsset>? {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return nil }
        fetchResult = changes.fetchResultAfterChanges
        return changes
    }

    func delta(of preheatRect: CGRect) -> CGFloat {
        return abs(preheatRect.midY - previousPreheatRect.midY)
    }

    func differencesBetweenRects(_ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if previousPreheatRect.intersects(new) {
            var added = [CGRect]()
            if new.maxY > previousPreheatRect.maxY {
                added += [CGRect(x: new.origin.x, y: previousPreheatRect.maxY,
                                 width: new.width, height: new.maxY - previousPreheatRect.maxY)]
            }
            if previousPreheatRect.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: previousPreheatRect.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < previousPreheatRect.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: previousPreheatRect.maxY - new.maxY)]
            }
            if previousPreheatRect.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: previousPreheatRect.minY,
                                   width: new.width, height: new.minY - previousPreheatRect.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [previousPreheatRect])
        }
    }

    func updateCachedAssets(addedAssets: [IndexPath], removedAssets: [IndexPath], newRect preheatRect: CGRect) {
        // Update the assets the PHCachingImageManager is caching.
        let addedAssets = addedAssets.map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedAssets.map { indexPath in fetchResult.object(at: indexPath.item) }
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
}
