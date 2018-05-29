//
//  ViewController.swift
//  PhotosApp
//
//  Created by TaeHyeonLee on 2018. 5. 21..
//  Copyright © 2018년 ChocOZerO. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let photosManager = PhotosManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = "Photos"
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosManager.fetchResultCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
            as? PhotosCollectionViewCell else { fatalError("unexpected cell in collection view") }
        cell.representedAssetIdentifier = photosManager.localIdentifier(at: indexPath.item)
        photosManager.requestImage(at: indexPath.item) { image  in
            cell.thumbnailImage = image
        }
        return cell
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            guard let changes = photosManager.photoLibraryDidChange(changeInstance) else { return }
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
                guard let collectionView = self.collectionView else { fatalError() }
                collectionView.performBatchUpdates({
                    // For indexes to make sense, updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, removed.count > 0 {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view if incremental diffs are not available.
                collectionView!.reloadData()
            }
            photosManager.resetCachedAssets()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
}

// MARK: Asset Caching
extension ViewController {
    private func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }

        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)

        // Update only if the visible area is significantly different from the last preheated area.
        let delta = photosManager.delta(of: preheatRect)
        guard delta > view.bounds.height / 3 else { return }

        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = photosManager.differencesBetweenRects(preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
        photosManager.updateCachedAssets(addedAssets: addedAssets, removedAssets: removedAssets, newRect: preheatRect)
    }
}

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}
