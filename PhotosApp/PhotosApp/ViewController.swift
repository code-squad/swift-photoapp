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
    
    private let photos = PhotoAssets()
    
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
        return photos.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,
                                                      for: indexPath)
        guard let photoCell = cell as? PhotosCollectionViewCell,
            let photoAsset = photos[indexPath.item] else { return cell }
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
        
    }
}
