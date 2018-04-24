//
//  ViewController.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 12..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    private var photoService: PhotoService!
    private var selectedItems: [PHAsset] = [] {
        willSet {
            doneButton.isEnabled = newValue.count > 2 ? true : false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView(notification:)),
                                               name: .photoLibraryChanged, object: nil)
        collectionView.allowsMultipleSelection = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoService.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        cell.representedAssetIdentifier = photoService.at(indexPath.item).localIdentifier
        photoService.requestImage(at: indexPath.item) { image, isLivePhoto  in
            cell.photoImageView.image = image
            cell.liveBadgeImageView.image = isLivePhoto ? PHLivePhotoView.livePhotoBadgeImage(options: .overContent) : nil
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewConfig.itemSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItems.append(photoService.at(indexPath.item))
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedItems.index(of: photoService.at(indexPath.item)) {
            selectedItems.remove(at: index)
        }
    }

    @IBAction func isDone(_ sender: UIBarButtonItem) {
        let selectedImages = photoService.requestImages(from: selectedItems)
        let videoMaker = try? VideoMaker(videoSize: ViewConfig.itemSize, playSeconds: 3)
        videoMaker?.makeVideo(from: selectedImages) { videoUrl in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
            }, completionHandler: { (isSaved, error) in
                isSaved ? self.showOKAlert("3초 동영상이 추가되었습니다.") : nil
            })
        }
    }

    private func deselectAllSelectedItems() {
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: true)
            if let index = selectedItems.index(of: photoService.at($0.item)) {
                selectedItems.remove(at: index)
            }
        }
    }

    private func showOKAlert(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "확인", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true) {
            self.deselectAllSelectedItems()
        }
    }

}

extension ViewController {
    @objc func updateCollectionView(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let changes = userInfo[NotificationKeys.photoChanges] as? PHFetchResultChangeDetails<PHAsset> else { return }
        DispatchQueue.main.async {
            changes.hasIncrementalChanges ? self.updateChangedItems(changes) : self.collectionView.reloadData()
        }
    }

    private func updateChangedItems(_ changes: PHFetchResultChangeDetails<PHAsset>) {
        self.collectionView.performBatchUpdates({
            if let insertedIndexes = changes.insertedIndexes, insertedIndexes.count > 0 {
                self.collectionView.insertItems(at: insertedIndexes.compactMap { IndexPath(row: $0, section: 0) })
            }
            if let deletedIndexes = changes.removedIndexes, deletedIndexes.count > 0 {
                self.collectionView.deleteItems(at: deletedIndexes.compactMap { IndexPath(row: $0, section: 0) })
            }
            if let changedIndexes = changes.changedIndexes, changedIndexes.count > 0 {
                self.collectionView.reloadItems(at: changedIndexes.compactMap { IndexPath(row: $0, section: 0) })
            }
            if changes.hasMoves {
                changes.enumerateMoves {
                    self.collectionView.moveItem(at: IndexPath(row: $0, section: 0), to: IndexPath(row: $1, section: 0))
                }
            }
        }, completion: nil)
    }

}
