//
//  AddWorkoutViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/14/21.
//

import UIKit
import os.log

class AddWorkoutViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var benchButton: UIButton!
    @IBOutlet weak var squatButton: UIButton!
    @IBOutlet weak var deadliftButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var workout: Workout?
    var dateInput = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self
        benchButton.isSelected = true
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

        self.workout = Workout(name: nameInput, weight: weightInput, date: self.dateInput, photo: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let weightText = weightTextField.text ?? ""
        saveButton.isEnabled = !weightText.isEmpty
    }
}
