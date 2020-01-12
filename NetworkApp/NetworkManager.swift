//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by User on 10/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

class NetworkManager {
    static func get(url: String) {
        guard let url = URL(string: url) else {return}

        let session = URLSession.shared

        session.dataTask(with: url) { (data, response, error) in
            guard let response = response, let data = data else {return}
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                print("URLSession")
            } catch {
                print (error)
            }
        }.resume()
    }
    
    
    static func getImage(url: String, completion: @escaping (_ image: UIImage) -> () ) {
       
        guard let url = URL(string: url) else {return}
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func postRequest(urlLink: String, data: Any) {
        
        guard let url = URL(string: urlLink) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: data, options: []) else {return}
        
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                print("URLSession")
            } catch {
                print("HTTP request failed \(error)")
                print("URLSession")
            }
        }.resume()
    }
    
    static func getCourses(url: String, completion: @escaping ([Course])->() ) {
        guard let url = URL(string: url) else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let loadCourses = try JSONDecoder().decode([Course].self, from: data)
                print("URLSession")
                completion(loadCourses)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
