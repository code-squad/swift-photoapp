//
//  NetworkManager.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation

class NetworkManager {
    private let session = URLSession(configuration: .default)
    
    func download(with url: URL, successHandler: @escaping (Data) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode else { return }
            
            successHandler(data)
        }.resume()
    }
}
