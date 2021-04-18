//
//  AddWorkoutViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/14/21.
//
import UIKit
import OSLog

class AddWorkoutViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var benchButton: UIButton!
    @IBOutlet weak var squatButton: UIButton!
    @IBOutlet weak var deadliftButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var workout: Workout?
    var workoutData: WorkoutData?
    var dateInput = Date()
    
    private func setBackgrounds() {
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, UIColor(red: 252/255, green: 238/255, blue: 33/255, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView.
        backgroundGradientView.layer.addSublayer(gradientLayer)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgrounds()
        
        // Handle the text field’s user input through delegate callbacks.
        weightTextField.delegate = self
        
        // Set up views if editing an existing Workout.
        if let workout = workout {
            navigationItem.title = workout.name!
            weightTextField.text = workout.weight!
            datePicker.date = workout.date!
            
            switch(workout.name) {
            case "Bench Press":
                benchButton.isSelected = true
                //benchButton.setImage(UIImage(named: "filled-heart"), for: .normal)
            case "Squat":
                squatButton.isSelected = true
                //squatButton.setImage(UIImage(named: "filled-heart"), for: .normal)
            case "Deadlift":
                deadliftButton.isSelected = true
                deadliftButton.setImage(UIImage(named: "deadliftWithSquare"), for: .normal)
            default:
                break
            }
        }
        
        // Enable the Save button only if inputs are given.
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddWorkoutMode = self.presentingViewController != nil
        
        if isPresentingInAddWorkoutMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The AddWorkoutViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func benchButtonTapped(_ sender: Any) {
        guard benchButton.isSelected else {
            benchButton.isSelected = true
            if squatButton.isSelected {
                squatButton.isSelected = false
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected = false
            }
            return
        }
    }
    
    @IBAction func squatButtonTapped(_ sender: Any) {
        guard squatButton.isSelected else {
            squatButton.isSelected = true
            if benchButton.isSelected {
                benchButton.isSelected = false
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected = false
            }
            return
        }
    }
    
    @IBAction func deadliftButtonTapped(_ sender: Any) {
        guard deadliftButton.isSelected else {
            deadliftButton.isSelected = true
            deadliftButton.setImage(UIImage(named: "deadliftWithSquare"), for: .normal)
            if benchButton.isSelected {
                benchButton.isSelected = false
            } else if squatButton.isSelected {
                squatButton.isSelected = false
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

        self.workoutData = WorkoutData(name: nameInput, weight: weightInput, date: dateInput)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if benchButton.isSelected || squatButton.isSelected || deadliftButton.isSelected {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let weightText = weightTextField.text ?? ""
        saveButton.isEnabled = !weightText.isEmpty
    }
}
