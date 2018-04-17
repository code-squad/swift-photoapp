//
//  Reusable.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 16..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Foundation

protocol Reusable {
    static var id: String { get }
}

extension Reusable {
    static var id: String {
        return String(describing: self)
    }
}
