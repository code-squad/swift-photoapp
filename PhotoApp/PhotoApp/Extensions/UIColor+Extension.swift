//
//  UIColor+Extension.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 17..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
