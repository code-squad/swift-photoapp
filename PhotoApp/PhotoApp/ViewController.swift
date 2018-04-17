//
//  ViewController.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 12..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    private var photoService: PhotoService! {
        didSet {
            photoService.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoService = PhotoService()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoService.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        photoService.requestImage(at: indexPath.item) { image in
            cell.photoImageView.image = image
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ViewConfig.itemWidth, height: ViewConfig.itemHeight)
    }

}

extension ViewController: UpdateCollectionViewDelegate {
    func updateCollectionView(_ changes: PHFetchResultChangeDetails<PHAsset>) {
        changes.hasIncrementalChanges ? updateChangedItems(changes) : self.collectionView.reloadData()
    }

    private func updateChangedItems(_ changes: PHFetchResultChangeDetails<PHAsset>) {
        self.collectionView.performBatchUpdates({
            if let insertedIndexes = changes.insertedIndexes, insertedIndexes.count > 0 {
                self.collectionView.insertItems(at: insertedIndexes.compactMap { IndexPath(index: $0) })
            }
            if let deletedIndexes = changes.removedIndexes, deletedIndexes.count > 0 {
                self.collectionView.deleteItems(at: deletedIndexes.compactMap { IndexPath(index: $0) })
            }
            if let changedIndexes = changes.changedIndexes, changedIndexes.count > 0 {
                self.collectionView.reloadItems(at: changedIndexes.compactMap { IndexPath(index: $0) })
            }
            changes.enumerateMoves { self.collectionView.moveItem(at: IndexPath(index: $0), to: IndexPath(index: $1)) }
        })
    }

}
