//
//  ViewController.swift
//  NetworkApp
//
//  Created by User on 10/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var colletionView: UICollectionView!
    
    enum Actions: String, CaseIterable {
        case get = "GET"
        case post = "POST"
        case downloadImage = "Download image"
        case downloadFile = "Download file"
        case parsingCourses = "Parsing courses"
    }
    
    let actions = Actions.allCases
    var segueSwitch = ""
    let urlGet = "https://jsonplaceholder.typicode.com/posts"
    let dataProvider = DataProvider()
    private var filePath: String?
    private var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.fileLocation = {(location) in
            print("Download COMPLITE, filePath: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
        }
    }
    
    // Возможно, это один из самых странных способов навигации, что Вы видели....
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueVC = segue.destination as? ImageViewController
        let seguePV = segue.destination as? PostViewController
        let segueCC = segue.destination as? TableViewController
        
        switch segue.identifier {
        case "Image":
            segueVC?.segueSwitch = ""
        case "ImageAlamofire":
            segueVC?.segueSwitch = "Alamofire"
        case "Post":
            seguePV?.segueSwitch = ""
        case "PostAlamofire":
            seguePV?.segueSwitch = "Alamofire"
        case "Courses":
            segueCC?.loadURL()
        case "CoursesAlamofire":
            segueCC?.loadAlamofire()
        default:
            break
        }
    }

    @IBAction func segmentedSwitch(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segueSwitch = ""
            segmentedControl.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case 1:
            segueSwitch = "Alamofire"
            segmentedControl.tintColor = .red
        default:
            break
        }
    }
    
    
    func ShowAlert() {
        alert = UIAlertController(title: "Download...", message: "0%", preferredStyle: .alert)
        let constraintHeight = NSLayoutConstraint(item: alert.view as Any,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 0,
                                                  constant: 170)

        alert.view.addConstraint(constraintHeight)

        let alertAction = UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            self.dataProvider.StopDownload()
        }

        alert?.addAction(alertAction)
        present(alert!, animated: true) {

            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2 , y: self.alert.view.frame.height / 2 - size.height / 2)

            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .blue
            activityIndicator.startAnimating()

            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))

            progressView.tintColor = .blue

            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }

            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.cellLabel.text = actions[indexPath.row].rawValue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "Image\(segueSwitch)", sender: self)
        case .parsingCourses:
            performSegue(withIdentifier: "Courses\(segueSwitch)", sender: self)
        case .post:
            performSegue(withIdentifier: "Post\(segueSwitch)", sender: self)
        case .get:
            if segueSwitch == "" {
            NetworkManager.get(url: urlGet)
            } else {
                Alamofire.getAlamofire(url: urlGet)
            }
        case .downloadFile:
            
            if segueSwitch == "" {
            dataProvider.StartDownload()
            ShowAlert()
            } else {
            SharedClass.sharedInstance.alert(view: self)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

