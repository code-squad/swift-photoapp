//
//  PhotoConverter.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 13..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation
import Photos

struct PhotoConverter {
    func convert(with asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let manager = PHCachingImageManager.default()
        manager.requestImage(for: asset,
                              targetSize: .init(width: Configuration.Image.width,
                                                height: Configuration.Image.height),
                              contentMode: .aspectFill,
                              options: nil) { (image, _) in
                                completion(image)
        }
    }
}
