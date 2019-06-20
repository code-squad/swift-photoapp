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
    
    override var isSelected: Bool {
        didSet {
            let transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.selectedBackgroundView?.transform = transform
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        self.selectedBackgroundView = view
    }
    
    static let identifier = "photosCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        livePhotobadgeImageView.image = nil
    }
}
