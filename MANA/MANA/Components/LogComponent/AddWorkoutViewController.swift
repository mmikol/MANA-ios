//
//  AddWorkoutViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/14/21.
//

import UIKit
import os.log

class AddWorkoutViewController: UIViewController {
    @IBOutlet weak var benchButton: UIButton!
    @IBOutlet weak var squatButton: UIButton!
    @IBOutlet weak var deadliftButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var workout: Workout?
    var dateInput = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func benchButtonTapped(_ sender: Any) {
        guard benchButton.isSelected else {
            benchButton.isSelected.toggle()
            if squatButton.isSelected {
                squatButton.isSelected.toggle()
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected.toggle()
            }
            return
        }
    }
    
    @IBAction func squatButtonTapped(_ sender: Any) {
        guard squatButton.isSelected else {
            squatButton.isSelected.toggle()
            if benchButton.isSelected {
                benchButton.isSelected.toggle()
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected.toggle()
            }
            return
        }
    }
    
    @IBAction func deadliftButtonTapped(_ sender: Any) {
        guard deadliftButton.isSelected else {
            deadliftButton.isSelected.toggle()
            if benchButton.isSelected {
                benchButton.isSelected.toggle()
            } else if squatButton.isSelected {
                squatButton.isSelected.toggle()
            }
            return
        }
    }
    
 
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.dateInput = sender.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameInput = (benchButton.isSelected ? "Bench Press" :
                    squatButton.isSelected ? "Squat" :
                    deadliftButton.isSelected ? "Deadlift" : "")
        let weightInput = weightTextField.text ?? ""
        let repsInput = repsTextField.text ?? ""

        self.workout = Workout(name: nameInput, weight: weightInput, reps: repsInput, date: self.dateInput, photo: nil)
        
    }

    // Add implementation to only enable one button

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
