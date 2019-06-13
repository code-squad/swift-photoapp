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
    
    static let identifier = "photosCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
