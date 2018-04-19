//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 16..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.translatesAutoresizingMaskIntoConstraints = false
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            photoImageView.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet weak var liveBadgeImageView: UIImageView! {
        didSet {
            liveBadgeImageView.translatesAutoresizingMaskIntoConstraints = false
            liveBadgeImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
            liveBadgeImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
            liveBadgeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            liveBadgeImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        liveBadgeImageView.image = nil
    }

}
