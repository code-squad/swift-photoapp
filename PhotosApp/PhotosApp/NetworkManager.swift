//
//  NetworkManager.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation

class NetworkManager {
    private let session: URLSession
    var time = CFAbsoluteTime()
    
    init() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        self.session = URLSession(configuration: .default,
                                  delegate: nil,
                                  delegateQueue: queue)
    }
    
    func download(with url: URL, successHandler: @escaping (Data) -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode else { return }
            
            successHandler(data)
            let end = CFAbsoluteTimeGetCurrent() - start
            self.time += end
            print(self.time)
        }.resume()
    }
}
