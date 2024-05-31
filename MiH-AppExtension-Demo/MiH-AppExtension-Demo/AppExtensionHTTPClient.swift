//
//  AppExtensionHTTPClient.swift
//  MiH-AppExtension-Demo
//
//  Created by Riccardo Cecchini on 31/05/24.
//

import Foundation

class AppExtensionHTTPClient {
    
    func makeRequest(path: String) -> URL{
        let url = URL(string: "http://127.0.0.1:19494"+path)!
        return url
    }
    
    func connect(){
        let url = makeRequest(path: "/connect")

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //let image = UIImage(data: data)
                print("response", data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()

    }
}
