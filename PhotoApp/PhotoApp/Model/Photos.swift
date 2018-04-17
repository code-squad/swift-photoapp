//
//  Photos.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 16..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Photos

struct Photos: Sequence {
    private var photoAssets = PHFetchResult<PHAsset>()
    let start: Int = 0

    init() {
        self.photoAssets = self.fetchAllPhotosFromLibrary()
    }

    func makeIterator() -> IteratorForPHFetchResult<PHAsset> {
        return IteratorForPHFetchResult(self.photoAssets)
    }
}

extension Photos {
    private func fetchAllPhotosFromLibrary() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: options)
    }

    func at(_ index: Int) -> PHAsset {
        return photoAssets.object(at: index)
    }

    var count: Int {
        return photoAssets.count
    }
}

struct IteratorForPHFetchResult<Type: NSObject>: IteratorProtocol {
    typealias Element = Type
    private let elements: PHFetchResult<Element>
    private var nextIndex: Int
    init(_ elements: PHFetchResult<Element>) {
        self.nextIndex = 0
        self.elements = elements
    }

    mutating func next() -> Element? {
        defer { self.nextIndex += 1 }
        guard self.nextIndex < self.elements.count else { return nil }
        return self.elements[self.nextIndex]
    }
}
