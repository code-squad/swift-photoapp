//
//  ClassIterator.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 17..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Photos

class ClassIterator<Type: NSObject>: IteratorProtocol {
    typealias Element = Type
    private let elements: PHFetchResult<Element>
    private var nextIndex: Int
    init(_ elements: PHFetchResult<Element>) {
        self.nextIndex = 0
        self.elements = elements
    }

    func next() -> Element? {
        defer { self.nextIndex += 1 }
        guard self.nextIndex < self.elements.count else { return nil }
        return self.elements.object(at: self.nextIndex)
    }

}
