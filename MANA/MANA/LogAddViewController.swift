//
//  LogAddViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/2/21.
//

import UIKit

class LogAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    struct Exercise {
        let name: String
        let weight: Int
        let numberOfSets: Int
        let numberOfRepsPerSet: Int
        let image: UIImage // Could be wrong data type
        
    }
    
    struct LogEntry {
        let name: String?
        let date: Date
        let exercises: Array<Exercise>
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
