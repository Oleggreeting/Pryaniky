//
//  NetworkService.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import Foundation

class NetworkService {
    static func fetch(completion: @escaping(ModelData)->()) {
        let string = "https://pryaniky.com/static/json/sample.json"
        
        guard let url = URL(string: string) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(response as Any)
            } else if let data = data {
                do {
                    let json = try JSONDecoder().decode(ModelData.self, from:data )
                    DispatchQueue.main.async {
                        completion(json)
                    }
                    
                } catch {
                    print(error)
                }                
            }
        }
        task.resume()
    }
}
