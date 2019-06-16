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
        let converter = PhotoConverter()
        converter.convert(with: photoAsset) { (image) in
            photoCell.photoImageView.image = image
        }

        return photoCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Configuration.Image.width,
                     height: Configuration.Image.height)
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

