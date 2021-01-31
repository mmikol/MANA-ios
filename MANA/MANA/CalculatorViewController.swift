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
    @IBOutlet weak var plate2Button: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    var currentComputation: Float = 0.0
    var computationStack = Stack()

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
            currentComputation -= computationStack.pop()!
            return
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        currentComputation = 0
        computationStack = Stack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionButton.isSelected.toggle()
        computationLabel.text = "\(currentComputation)"
        // Do any additional setup after loading the view.
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
