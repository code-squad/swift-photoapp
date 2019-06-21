//
//  NetworkManager.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation

class NetworkManager {
    private let downloadSessions = Array(repeating: URLSession(configuration: .default), count: 10)
    
    func download(with url: URL, successHandler: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode else { return }
            
            successHandler(data)
        }.resume()
    }
    
    func download(with url: URL, for index: Int , successHandler: @escaping (Data) -> Void) {
        downloadSessions[index % downloadSessions.count].dataTask(with: url) { (data, response, error) in
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
