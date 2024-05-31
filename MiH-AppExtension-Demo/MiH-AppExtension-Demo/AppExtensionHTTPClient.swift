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
    
    func makePostRequest(url: URL, json: [String: Any]) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // Create the JSON data to be sent in the request body
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])

        // Add the JSON data to the request body
        request.httpBody = jsonData
        
        return request

        /* USAGE EXAMPLE
        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON response data
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response JSON: \(jsonResponse)")
                } catch {
                    print("Failed to parse JSON response: \(error)")
                }
            }
        }
         */
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
