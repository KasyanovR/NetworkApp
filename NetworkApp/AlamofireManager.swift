//
//  AlamofireManager.swift
//  NetworkApp
//
//  Created by User on 10/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit
import Alamofire

class Alamofire {
    
    
    static func getAlamofire(url: String) {
        AF.request(url).validate().responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {return}
            print("Alamofire. Status code: \(statusCode)")
            switch response.result {
            case .success(let data):
                print(data)
                print("Alamofire")
            case .failure(let error):
                print("HTTP request failed \(error)")
            }
        }
    }
    
    
    static func postAlamofire(urlLink: String, data: [String:Any]) {
        let headers: HTTPHeaders = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        
        AF.request(urlLink, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                guard let statusCode = response.response?.statusCode else {return}
                print("Alamofire. StatusCode: \(statusCode)")
                switch response.result {
                case .success(let data):
                    print(data)
                    print("Alamofire")
                case.failure(let error):
                    print("HTTP request failed: \(error)")
                    print("Alamofire")
                }
            }
    }
    
    static func getImageAlamofire(url: String, completion: @escaping (_ image: UIImage)->()) {
        AF.request(url).validate().responseData { (response) in
            guard let statusCode = response.response?.statusCode else {return}
            print("Alamofire. StatusCode: \(statusCode)")
            switch response.result {
            case .success(let data):
                guard let image = UIImage(data: data) else {return}
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getCoursesAlamofire(url:String, completion: @escaping (_ courses: [Course])->()) {
        AF.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success(let json):
                guard let jsonArray = json as? [[String: Any]] else {return}
                var courses = [Course]()
                for field in jsonArray {
                    if let course = Course(json: field) {
                    courses.append(course)
                    }
                }
                print("Alamofire")
                completion(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
}
