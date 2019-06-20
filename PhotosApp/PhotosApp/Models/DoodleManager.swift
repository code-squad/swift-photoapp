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
            NotificationCenter.default.post(name: .doodlesDidDownload, object: self)
        }
        networkManager.download(with: url, successHandler: successHandler)
    }
    
    func perform(with dataHandler: @escaping (Data) -> Void, from index: Int) {
        let networkManager = NetworkManager()
        let doodle = doodles[index]
        guard let url = URL(string: doodle.image) else { return }
        networkManager.download(with: url, successHandler: dataHandler)
    }
}

extension NSNotification.Name {
    static let doodlesDidDownload = NSNotification.Name("doodlesDidDownload")
}
