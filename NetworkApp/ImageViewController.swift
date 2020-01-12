//
//  ImageViewController.swift
//  NetworkApp
//
//  Created by User on 10/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    let url = "https://i.imgur.com/3416rvI.jpg"
    var segueSwitch = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    @IBAction func tap() {
        button.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        switch segueSwitch {
        case "":
            NetworkManager.getImage(url: url) { (image) in
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                print("URLSession")
            }
        case "Alamofire":
            Alamofire.getImageAlamofire(url: url) { (image) in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            }
        default:
            break
        }
        button.isEnabled = true
    }
}
