//
//  Configuration.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 13..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation

struct Configuration {
    struct Image {
        static let width = 100
        static let height = 100
    }
    
    struct Video {
        static let width = 640
        static let height = 480
        static let playTime = 3
    }
    
    struct DoodleViewController {
        struct Item {
            static let width = 110
            static let height = 50
        }
        static let doodlesURL = "http://101.101.164.187/doodle.php"
    }
}
