//
//  AppExtensionHTTPClient.swift
//  MiH-AppExtension-Demo
//
//  Created by Riccardo Cecchini on 31/05/24.
//

import Foundation

class AppExtensionHTTPClient {
    
    func makeRequest(path: String) -> URL{
        let url = URL(string: "http://127.0.0.1:19494/appExtension"+path)!
        return url
    }
    
    func connect(bundleId:String){
        let url = makeRequest(path: "/connect?bundleId="+bundleId)

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //let image = UIImage(data: data)
                print("response", String(data: data, encoding: .utf8))
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()

    }
}
