//
//  CalculatorViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//
import UIKit

class CalculatorViewController: UIViewController {
    struct CalculatorStack {
        var stack: [Any] = []
        var isEmpty: Bool { return stack.isEmpty }
        
        mutating func push(_ element: Any) {
            stack.append(element)
            
            if stack.count >= 25 {
                stack.removeFirst()
            }
        }

        mutating func pop() -> Any? {
            return stack.popLast()
        }
        
        mutating func clear() {
            stack.removeAll()
        }
    }

    let numberFormatter = NumberFormatter();
    var currentComputation = 45
    var computationStack = CalculatorStack()

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
            currentComputation += computationStack.pop() as! Int
            computationLabel.text = "\(currentComputation) lbs"
            return
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        currentComputation = 45
        computationStack.clear()
        computationLabel.text = "\(currentComputation) lbs"
    }
    
    @IBAction func plate45ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 90
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate35ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 70
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate25ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 50
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate10ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 20
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate5ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 10
        adjustComputation(By: TWO_PLATE_VALUE)
    }

    @IBAction func plate2ButtonTapped(_ sender: Any) {
        let TWO_PLATE_VALUE = 5
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    func adjustComputation(By amount: Int) {
        guard currentComputation == 0 && subtractionButton.isSelected else {
            let increment = additionButton.isSelected ? amount : -amount
            let newValue = currentComputation + increment
            
            if newValue >= 0 && newValue < 50000 {
                currentComputation += increment
                computationStack.push(-increment)

                let formattedNumber = numberFormatter.string(from: NSNumber(value:currentComputation))
                
                computationLabel.text = "\(formattedNumber!) lbs"
            } else if newValue >= 50000 {
                computationLabel.text = "Godlike MANA"
            }
            
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionButton.isSelected.toggle()
        computationLabel.text = "\(currentComputation) lbs"
        numberFormatter.numberStyle = .decimal
    }
}
