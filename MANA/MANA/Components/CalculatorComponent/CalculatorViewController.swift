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

    let numberFormatter = NumberFormatter()
    
    var currentComputation = 0
    var computationStack = CalculatorStack()
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var computationLabel: UILabel!
    @IBOutlet weak var plate45Button: UIButton!
    @IBOutlet weak var plate35Button: UIButton!
    @IBOutlet weak var plate25Button: UIButton!
    @IBOutlet weak var plate10Button: UIButton!
    @IBOutlet weak var plate5Button: UIButton!
    @IBOutlet weak var plate2Button: UIButton! // Represents 2.5lbs
    @IBOutlet weak var smallBarButton: UIButton!
    @IBOutlet weak var largeBarButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func additionButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard additionButton.isSelected else {
            additionButton.isSelected.toggle()
            additionButton.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            if subtractionButton.isSelected {
                subtractionButton.isSelected.toggle()
                subtractionButton.backgroundColor = #colorLiteral(red: 0.9207075238, green: 0.832200706, blue: 0.2110097706, alpha: 1)
            }
            return
        }
    }
    
    @IBAction func subtractionButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard subtractionButton.isSelected else {
            subtractionButton.isSelected.toggle()
            additionButton.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            if additionButton.isSelected {
                additionButton.isSelected.toggle()
                additionButton.backgroundColor = #colorLiteral(red: 0.9207075238, green: 0.832200706, blue: 0.2110097706, alpha: 1)
            }
            
            if !smallBarButton.isEnabled || !largeBarButton.isEnabled {
                smallBarButton.isEnabled = true
                largeBarButton.isEnabled = true
            }
            
            return
        }
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard computationStack.isEmpty else {
            currentComputation += computationStack.pop() as! Int
            computationLabel.text = "\(currentComputation) lbs"
            
            if !smallBarButton.isEnabled || !largeBarButton.isEnabled {
                smallBarButton.isEnabled = true
                largeBarButton.isEnabled = true
            }
            
            return
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        currentComputation = 0
        computationStack.clear()
        computationLabel.text = "\(currentComputation) lbs"
        smallBarButton.isEnabled = true
        largeBarButton.isEnabled = true
    }
    
    @IBAction func plate45ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 90
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate35ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 70
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate25ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 50
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate10ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 20
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func plate5ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 10
        adjustComputation(By: TWO_PLATE_VALUE)
    }

    @IBAction func plate2ButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }
        let TWO_PLATE_VALUE = 5
        adjustComputation(By: TWO_PLATE_VALUE)
    }
    
    @IBAction func smallBarButtonTapped(_ sender: Any) {
        let SMALL_BAR_VALUE = 25
        adjustComputation(By: SMALL_BAR_VALUE)
        smallBarButton.isEnabled = false
        largeBarButton.isEnabled = false
    }
    
    @IBAction func largeBarButtonTapped(_ sender: Any) {
        let LARGE_BAR_VALUE = 45
        adjustComputation(By: LARGE_BAR_VALUE)
        smallBarButton.isEnabled = false
        largeBarButton.isEnabled = false
    }
    
    func adjustComputation(By amount: Int) {
        guard currentComputation == 0 && subtractionButton.isSelected else {
            let increment = additionButton.isSelected ? amount : -amount
            let newValue = currentComputation + increment
            
            if newValue >= 0 && newValue < 50000 {
                currentComputation += increment
                computationStack.push(-increment)
                let formattedNumber = numberFormatter.string(from: NSNumber(value: currentComputation))
                computationLabel.text = "\(formattedNumber!) lbs"
            } else if newValue >= 50000 {
                computationLabel.text = "Godlike MANA"
            }
            
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        computationLabel.text = "\(currentComputation) lbs"
        numberFormatter.numberStyle = .decimal
    }
}
