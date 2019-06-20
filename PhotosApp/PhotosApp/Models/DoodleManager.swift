//
//  DoodleManager.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation

class DoodleManager {
    private var doodles = [Doodle]()
    var count: Int {
        return doodles.count
    }
    
    func setUp(with url: String) {
        guard let url = URL(string: url) else { return }
        let networkManager = NetworkManager()
        let successHandler = { (data: Data) -> Void in
            guard let doodles = try? JSONDecoder().decode([Doodle].self, from: data) else { return }
            self.doodles.append(contentsOf: doodles)
        }
        networkManager.download(with: url, successHandler: successHandler)
    }
}
