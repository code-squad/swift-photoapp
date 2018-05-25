//
//  PhotosCollectionViewCell.swift
//  PhotosApp
//
//  Created by TaeHyeonLee on 2018. 5. 21..
//  Copyright © 2018년 ChocOZerO. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var representedAssetIdentifier: String!

    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
