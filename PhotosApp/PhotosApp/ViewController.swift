//
//  ViewController.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 12..
//  Copyright © 2019 hngfu. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!

    private var photoAssets = PHAsset.fetchAssets(with: nil)
    private let imageManager = PHCachingImageManager()
    private var previousPreheatRect = CGRect.zero
    private let thumbnailSize = CGSize(width: Configuration.Image.width,
                                       height: Configuration.Image.height)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        PHPhotoLibrary.shared().register(self)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,
                                                      for: indexPath)
        guard let photoCell = cell as? PhotosCollectionViewCell else { return cell }
        let photoAsset = photoAssets.object(at: indexPath.item)
        let resultHandler = { (image: UIImage?, _: [AnyHashable: Any]?) -> Void in
            photoCell.photoImageView.image = image
        }
        imageManager.requestImage(for: photoAsset,
                                  targetSize: thumbnailSize,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: resultHandler)

        return photoCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    private func updateCachedAssets() {
        let visibleRect = CGRect(origin: photosCollectionView.contentOffset,
                                 size: photosCollectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        let (addedRect, removedRect) = differencesBetweenRects(previousPreheatRect, preheatRect)
        guard let addedIndexPaths = photosCollectionView.indexPathsForElements(in: addedRect),
            let removedIndexPaths = photosCollectionView.indexPathsForElements(in: removedRect) else { return }
        let addedAssets = addedIndexPaths.map { photoAssets.object(at: $0.item) }
        let removedAssets = removedIndexPaths.map { photoAssets.object(at: $0.item) }
        
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize,
                                        contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize,
                                       contentMode: .aspectFill, options: nil)

        previousPreheatRect = preheatRect
    }
    
    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: CGRect, removed: CGRect) {
        if old.intersects(new) {
            let added: CGRect
            let removed: CGRect
            if new.maxY > old.maxY {
                added = CGRect(x: new.origin.x, y: old.maxY,
                               width: new.width, height: new.maxY - old.maxY)
                removed = CGRect(x: new.origin.x, y: old.minY,
                                 width: new.width, height: new.minY - old.minY)
            } else {
                added = CGRect(x: new.origin.x, y: new.minY,
                               width: new.width, height: old.minY - new.minY)
                removed = CGRect(x: new.origin.x, y: new.maxY,
                                 width: new.width, height: old.maxY - new.maxY)
            }
            return (added, removed)
        } else {
            return (new, old)
        }
    }
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: photoAssets) else { return }
        photoAssets = changes.fetchResultAfterChanges
        
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

extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath]? {
        guard let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect) else { return nil }
        return allLayoutAttributes.map { $0.indexPath }
    }
}
