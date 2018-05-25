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
    private let imageManager = PHCachingImageManager()
    private var fetchResult: PHFetchResult<PHAsset>!
    private var thumbnailSize: CGSize!
    private var previousPreheatRect = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = "Photos"

        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thumbnailSize = CGSize(width: 100, height: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
            as? PhotosCollectionViewCell else { fatalError("unexpected cell in collection view") }
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil,
            resultHandler: { image, _ in
                if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        return cell
    }
}
