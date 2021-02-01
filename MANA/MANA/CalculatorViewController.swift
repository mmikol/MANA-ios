//
//  CalculatorViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//
import UIKit

class CalculatorViewController: UIViewController {
    var currentComputation: Float = 0.0
    var computationStack = Utilities.Stack()
    
    @IBOutlet weak var computationLabel: UILabel!
    @IBOutlet weak var plate45Button: UIButton!
    @IBOutlet weak var plate35Button: UIButton!
    @IBOutlet weak var plate25Button: UIButton!
    @IBOutlet weak var plate10Button: UIButton!
    @IBOutlet weak var plate5Button: UIButton!
    @IBOutlet weak var plate2Button: UIButton! // Represents 2.5lbs
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func additionButtonTapped(_ sender: Any) {
        guard additionButton.isSelected else {
            additionButton.isSelected.toggle()
            if subtractionButton.isSelected {
                subtractionButton.isSelected.toggle()
            }
            return
        }
    }
    
    @IBAction func subtractionButtonTapped(_ sender: Any) {
        guard subtractionButton.isSelected else {
            subtractionButton.isSelected.toggle()
            if additionButton.isSelected {
                additionButton.isSelected.toggle()
            }
            return
        }
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        guard computationStack.isEmpty else {
            currentComputation += computationStack.pop()!
            computationLabel.text = "\(currentComputation)"
            return
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        currentComputation = 0
        computationStack = Utilities.Stack()
        computationLabel.text = "\(currentComputation)"
    }
    
    @IBAction func plate45ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 90.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate35ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 70.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate25ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 50.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate10ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 20.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate5ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 10.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }

    @IBAction func plate2ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 5.0
        adjustomputation(By: TWO_PLATE_VALUE)
    }
    
    func adjustomputation(By amount: Float) {
        guard currentComputation.isZero else {
            let increment = additionButton.isSelected ? amount : -amount
            currentComputation += increment
            computationStack.push(-increment)
            computationLabel.text = "\(currentComputation)"
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionButton.isSelected.toggle()
        computationLabel.text = "\(currentComputation)"
        // Do any additional setup after loading the view.
    }
}
