//
//  TableViewCell.swift
//  NetworkApp
//
//  Created by User on 10/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iV: UIImageView!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var lLesson: UILabel!
    @IBOutlet weak var lTest: UILabel!
    
    
    func setCell(course: Course) {
        if let name = course.name {
            lName.text = name
        }
        if let lesson = course.numberOfLessons {
            lLesson.text = "Number of lessons: \(lesson)"
        }
        if let test = course.numberOfTests {
            lTest.text = "Nuber of tests: \(test)"
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: course.imageUrl!) else {return}
            guard let dataSource = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.iV.image = UIImage(data: dataSource)
 
            }
        }
    }
}
