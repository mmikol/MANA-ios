//
//  CalculatorViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//

import UIKit

class CalculatorViewController: UIViewController {
    struct Stack {
        var stack: [Float] = []
        var isEmpty: Bool { return stack.isEmpty }
        
        mutating func push(_ element: Float) {
          stack.append(element)
        }

        mutating func pop() -> Float? {
          return stack.popLast()
        }
    }
    
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

    var currentComputation: Float
    var computationStack: Stack

    override func viewDidLoad() {
        super.viewDidLoad()
        currentComputation = 0.0
        computationStack = Stack()
        additionButton.isSelected.toggle()
        computationLabel.text = "\(currentComputation)"
        // Do any additional setup after loading the view.
    }
    
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
        computationStack = Stack()
        computationLabel.text = "\(currentComputation)"
    }
    
    @IBAction func plate45ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 90.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate35ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 70.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate25ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 50.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate10ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 20.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate5ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 10.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }

    @IBAction func plate2ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE: Float = 5.0
        incrementComputation(By: TWO_PLATE_VALUE)
    }
    
    func incrementComputation(By amount: Float) {
        guard currentComputation.isZero else {
            let increment = additionButton.isSelected ? amount : -amount
            currentComputation += increment
            computationStack.push(-increment)
            computationLabel.text = "\(currentComputation)"
            return
        }
    }
}
