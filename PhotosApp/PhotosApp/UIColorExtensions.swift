//
//  UIColorExtensions.swift
//  PhotosApp
//
//  Created by cocomilktea on 2019/10/21.
//  Copyright © 2019 cocomilktea. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func getRandomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}
