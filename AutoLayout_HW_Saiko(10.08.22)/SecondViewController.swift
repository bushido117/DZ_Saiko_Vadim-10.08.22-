//
//  SecondViewController.swift
//  AutoLayout_HW_Saiko(10.08.22)
//
//  Created by Вадим Сайко on 15.08.22.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var calculatorWorkings: UILabel!
    @IBOutlet var calculatorResults: UILabel!
    var workings = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        buttonsTargets()
    }
    
    fileprivate func clearAll() {
        workings = ""
        calculatorResults.text = ""
        calculatorWorkings.text = ""
    }
    
    @IBAction func allClearTap(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func backTap(_ sender: Any) {
        if !workings.isEmpty {
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }
    
    @IBAction func precentTap(_ sender: Any) {
        addToWorkings("%")
        if validInput() {
            let checkedWorkingForPrecent = workings.replacingOccurrences(of: "%", with: "* 0.01")
            let expression = NSExpression(format: checkedWorkingForPrecent)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultString = formatResult(result)
            calculatorWorkings.text = resultString
            calculatorResults.text = resultString
            workings = resultString
        } else {
            alert()
        }
    }
    
    @IBAction func equalTap(_ sender: Any) {
        if validInput() {
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultString = formatResult(result)
            calculatorResults.text = resultString
        } else {
            alert()
        }
    }
    
    fileprivate func validInput() -> Bool {
        var count = 0
        var funcCharIndexes = [Int]()
        
        for char in workings {
            if specialCharacter(char) {
                funcCharIndexes.append(count)
            }
            count += 1
        }
        var previous = -1
        
        for index in funcCharIndexes {
            if index == 0 && (workings.first != "-") {
                return false
            } else if (index == workings.count - 1) && (workings.last != "%") {
                return false
            }
            if previous != -1 {
                if index - previous == 1 {
                    return false
                }
            }
            previous = index
        }
        return true
    }
    
    func specialCharacter(_ char: Character) -> Bool {
        if char == "*" {
            return true
        } else  if char == "/" {
            return true
        } else  if char == "+" {
            return true
        } else  if char == "-" {
            return true
        } else if char == "%" {
            return true
        }
        return false
    }
    
    fileprivate func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(format: "%.2f", result)
        }
    }
    
    fileprivate func addToWorkings(_ value: String) {
        workings = workings + value
        calculatorWorkings.text = workings
    }
    
    fileprivate func buttonsTargets() {
        for button in buttons {
            let action = UIAction {_ in
                if let value = button.titleLabel?.text {
                self.addToWorkings(value)}
            }
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    fileprivate func alert() {
        let alert = UIAlertController(title: "Invalid Input", message: "Calculator unable to do math based on input", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove last entered symbol", style: .default, handler: { _ in
            self.workings.removeLast()
            self.calculatorWorkings.text = self.workings}))
        self.present(alert, animated: true, completion: nil)
    }
}

