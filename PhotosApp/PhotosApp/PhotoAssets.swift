//
//  PhotoAssets.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 13..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation
import Photos

class PhotoAssets {
    
    private var photoAssets = PHAsset.fetchAssets(with: .none)

    subscript(index: Int) -> PHAsset? {
        guard 0..<photoAssets.count ~= index else { return nil }
        return photoAssets.object(at: index)
    }
    
    func count() -> Int {
        return photoAssets.count
    }

    func fetchAssets() {
        photoAssets = PHAsset.fetchAssets(with: .none)
    }
}
