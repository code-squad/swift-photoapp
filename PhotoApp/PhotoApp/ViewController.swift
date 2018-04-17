//
//  ViewController.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 12..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    private let imageManager = PHCachingImageManager()
    private var photos: Photos! {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photos = Photos()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        let photo = photos.at(indexPath.item)
        imageManager.requestImage(for: photo,
                                  targetSize: CGSize(width: 100, height: 100),
                                  contentMode: .aspectFill,
                                  options: nil) { image, _ in cell.photoImageView.image = image }
        return cell
    }

}
