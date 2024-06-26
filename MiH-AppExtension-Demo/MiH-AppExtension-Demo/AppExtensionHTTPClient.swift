//
//  AppExtensionHTTPClient.swift
//  MiH-AppExtension-Demo
//
//  Created by Riccardo Cecchini on 31/05/24.
//

import Foundation

func jsonStringToDictionary(jsonString: String) -> [String: Any?]? {
    // Convert the JSON string to Data
    guard let jsonData = jsonString.data(using: .utf8) else {
        print("Failed to convert JSON string to Data")
        return nil
    }
    
    do {
        // Deserialize the JSON data into a dictionary
        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            // Convert the dictionary to [String: Any?]
            var resultDict: [String: Any?] = [:]
            for (key, value) in jsonDict {
                resultDict[key] = value
            }
            return resultDict
        } else {
            print("Failed to cast JSON object to [String: Any?]")
            return nil
        }
    } catch {
        print("Error deserializing JSON data: \(error)")
        return nil
    }
}

func encodeToBase64(_ input: String) -> String? {
    // Convert the input string to Data
    if let data = input.data(using: .utf8) {
        // Encode the Data to a Base64 string
        return data.base64EncodedString()
    }
    // Return nil if the string could not be converted to Data
    return nil
}

class AppExtensionHTTPClient {
    
    let bundleId = "ink.geckos.makeithome.MiH-AppExtension-Demo"
    var secret : String? = nil
    
    var viewController: ViewController?
    
    func makeRequest(path: String) -> URL{
        var pathWithBundle = path
        if pathWithBundle.contains("?"){
            pathWithBundle += "&"
        }
        else {
            pathWithBundle += "?"
        }
        
        pathWithBundle += "bundleId="+bundleId
        
        if self.secret != nil {
            pathWithBundle += "&secret="+secret!
        }
        
        let url = URL(string: "http://127.0.0.1:19494/appExtension"+pathWithBundle)!
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
         
        task.resume()
        */
    }
    
    func connect(){
        let url = makeRequest(path: "/connect")

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //let image = UIImage(data: data)
                let strResp = String(data: data, encoding: .utf8)
                print("response", strResp)
                
                if strResp != nil {
                    let resp = jsonStringToDictionary(jsonString: strResp!)
                    
                    if resp == nil {
                        print("!!! connect: Invalid JSON response")
                        return
                    }
                    
                    // secret
                    let secret = resp!["secret"] as? String
                    
                    if secret == nil {
                        print("!!! connect: secret is missing")
                        return
                    }
                    
                    self.secret = secret
                    
                    print("Successfully connected")
                    
                }
                else {
                    print("!!! connect: EMPTY RESPONSE !!!")
                }
                
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()

    }
    
    func setHtmlContent(content: String){
        let url = makeRequest(path: "/setHtmlContent")
        
        var body : [String: Any] = [:]
        body["content"] = encodeToBase64(content)
        
        let request = makePostRequest(url: url, json: body)
        
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
        
        task.resume()
    }
    
    func sendJSMessage(jsMessage: String){
        let url = makeRequest(path: "/sendJSMessage")
        
        var body : [String: Any] = [:]
        body["jsMessage"] = jsMessage
        
        let request = makePostRequest(url: url, json: body)
        
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
        
        task.resume()
    }
    
    func checkStatus(){
        let url = makeRequest(path: "/checkStatus")

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = String(data: data, encoding: .utf8)
                print("response", response)
                
                DispatchQueue.main.async {
                    self.viewController?.textStatus?.stringValue = response ?? ""
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
    
    func waitForStatus(){
        let url = makeRequest(path: "/waitForStatus")

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = String(data: data, encoding: .utf8)
                print("response", response)
                
                DispatchQueue.main.async {
                    self.viewController?.textStatus?.stringValue = response ?? ""
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
}
