//
//  PutViewController.swift
//  NetworkApp
//
//  Created by User on 11/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit
import Alamofire

class PostViewController: UIViewController {

    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var lackLabel: UILabel!
    
    @IBOutlet weak var stepperHappy: UIStepper!
    @IBOutlet weak var stepperHealth: UIStepper!
    @IBOutlet weak var stepperLuck: UIStepper!
    
    let link = "https://jsonplaceholder.typicode.com/posts"
    var segueSwitch = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func happyAction(_ sender: UIStepper) {
        happyLabel.text = (String(Int(stepperHappy.value)))
    }
    @IBAction func healthAction(_ sender: UIStepper) {
        healthLabel.text = (String(Int(stepperHealth.value)))
    }
    @IBAction func luckAction(_ sender: UIStepper) {
        lackLabel.text = (String(Int(stepperLuck.value)))
    }
    
    @IBAction func sendButton() {
        let parameters = ["Happy": happyLabel.text, "Health": healthLabel.text, "Luck": lackLabel.text]
        if segueSwitch == "" {
        NetworkManager.postRequest(urlLink: link, data: parameters)
        } else {
        Alamofire.postAlamofire(urlLink: link, data: parameters as [String : Any])
        }
        
        lackLabel.text = "0"
        healthLabel.text = "0"
        happyLabel.text = "0"
        
        stepperHappy.value = 0
        stepperHealth.value = 0
        stepperLuck.value = 0
    }
}
