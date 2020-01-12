//
//  Alerts.swift
//  NetworkApp
//
//  Created by User on 12/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

import UIKit
class SharedClass: NSObject {
    static let sharedInstance = SharedClass()
    
    func alert(view: UIViewController) {
        let alert = UIAlertController(title: "Only by Session", message: "Sorry... ;-(", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Not great, not terrible.", style: .destructive, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
    private override init() {
    }
}
