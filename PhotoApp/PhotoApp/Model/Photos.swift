//
//  Photos.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 16..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Photos

class Photos: Sequence {
    private(set) var photoAssets = PHFetchResult<PHAsset>()
    let start: Int = 0

    init() {
        self.photoAssets = self.fetchAllPhotosFromLibrary()
    }

    public func makeIterator() -> ClassIterator<PHAsset> {
        return ClassIterator.init(self.photoAssets)
    }

}

extension Photos {
    private func fetchAllPhotosFromLibrary() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: options)
    }

    func at(_ index: Int) -> PHAsset {
        return photoAssets.object(at: index)
    }

    var count: Int {
        return photoAssets.count
    }

    func updateAssets(with changedAssets: PHFetchResult<PHAsset>) {
        self.photoAssets = changedAssets
    }
}

extension PHAsset {
    var isLivePhoto: Bool {
        return self.mediaSubtypes.contains(.photoLive)
    }
}
