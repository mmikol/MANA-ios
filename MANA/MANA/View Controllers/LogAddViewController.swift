//
//  LogAddViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/2/21.
//

import UIKit

class LogAddViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func submitButtonTapped(_ sender: Any) {
    }
    
    struct Exercise {
        let name: String
        let date: Date
        let weight: Int
        let numberOfSets: Int
        let numberOfRepsPerSet: Int        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
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
