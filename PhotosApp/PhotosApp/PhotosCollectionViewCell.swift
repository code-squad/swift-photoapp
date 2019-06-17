//
//  PhotosCollectionViewCell.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 13..
//  Copyright © 2019 hngfu. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var livePhotobadgeImageView: UIImageView!
    
    static let identifier = "photosCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        livePhotobadgeImageView.image = nil
    }
}
