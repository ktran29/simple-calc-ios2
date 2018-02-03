//
//  ViewController.swift
//  simplecalcios
//
//  Created by Kevin Tran on 1/24/18.
//  Copyright © 2018 Kevin Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!

    var numberString = "undef"
    var expression = ""
    var operation = ""
    var count : Double = 0
    var sum : Double = 0
    var storedValue : Double = 0
    var calculated = false
    var operated = false
    var historyBank : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        display.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        let buttonTitle : String? = sender.title(for: .normal)
        
        switch buttonTitle {
        case "0"?, "1"?, "2"?, "3"?, "4"?, "5"?, "6"?, "7"?, "8"?, "9"?:
            if calculated {
                display.text = "0"
                calculated = false
            }
            if display.text! == "0" || operated {
                display.text = buttonTitle!
                operated = false
            } else {
                display.text = display.text! + buttonTitle!
            }
            if numberString == "undef" {
                numberString = buttonTitle!
            } else {
                numberString += buttonTitle!
            }
        case "+"?, "-"?, "*"?, "/"?, "%"?:
            storeSimpleExpression(buttonTitle!)
        case "ct"?, "avg"?:
            storeComplexExpression(buttonTitle!)
        case "fact"?:
            operation = "fact"
            let value = calculate()
            display.text = String(value)
            if (numberString != "undef") {
                historyBank.append("\(Double(numberString)!)! = \(value)")
            }
            calculated = true
            reset()
        case "="?:
            let newValue = numberString != "undef" ? Double(numberString)! : 0
            expression = numberString != "undef" ? "\(expression) \(newValue)" : expression
            let updatedValue = isCommonOp() ? calculate(newValue) : calculate()
            if (isCommonOp()) {
                expression = numberString != "undef" ? "\(expression) = \(updatedValue)" : expression
            } else {
                expression = operation == "avg" ? "\(expression) / \(count) = \(updatedValue)" : "\(expression) = \(updatedValue)"
            }
            display.text = String(updatedValue)
            if expression != "" {historyBank.append(expression)}
            calculated = true
            reset()
        case "."?:
            if !numberString.contains(".") {
                if numberString == "undef" {
                    numberString = "."
                } else {
                    numberString += "."
                }
                display.text = display.text! + "."
            }
            
        case "+/-"?:
            if numberString != "undef" {
                if !numberString.starts(with: "-") {
                    numberString = "-" + numberString
                    display.text = numberString
                } else {
                    let index = numberString.index(numberString.startIndex, offsetBy: 1)
                    numberString = String(numberString[index...])
                    display.text = numberString
                }
            }
            
        default:
            break
        }
    }
    
    fileprivate func storeSimpleExpression(_ buttonTitle : String) -> Void {
        storedValue = numberString != "undef" ? Double(numberString)! : 0
        expression = numberString != "undef" ? "\(storedValue) \(buttonTitle)" : ""
        numberString = "undef"
        operation = buttonTitle
        operated = true
    }
    
    fileprivate func storeComplexExpression(_ buttonTitle : String) -> Void {
        if (numberString != "undef") {
            let value = Double(numberString)!
            sum += value
            if (operation == "avg") {
                expression = expression != "" ? "\(expression) + \(value)" : "\(value)"
            } else {
                expression = expression != "" ? "\(expression), \(value)" : "\(value)"
            }
        }
        count += 1
        numberString = "undef"
        operation = buttonTitle
        operated = true
    }
    
    fileprivate func calculate() -> Double {
        switch operation {
        case "avg":
            return sum / count
        case "ct":
            return count
        case "fact":
            var factorial : Double = 1;
            print(numberString)
            var start = numberString != "undef" ? Double(numberString)! : 0
            print(start)
            while start > 0 {
                factorial *= start
                start -= 1
            }
            return factorial
        default:
            return 0
        }
    }
    
    fileprivate func calculate(_ newValue: Double) -> Double {
        
        switch operation {
        case "+":
            return storedValue + newValue
        case "-":
            return storedValue - newValue
        case "*":
            return storedValue * newValue
        case "/":
            return storedValue / newValue
        case "%":
            while storedValue >= 0 {
                storedValue -= newValue
            }
            if (storedValue != 0) {
                storedValue += newValue
            }
            return storedValue
        default:
            return 0
        }
    }
    
    fileprivate func reset() -> Void {
        numberString = "undef"
        expression = ""
        operation = ""
        count = 0
        sum = 0
        storedValue = 0
        operated = false
    }
    
    fileprivate func isCommonOp() -> Bool {
        return operation == "+" || operation == "-" || operation == "*" || operation == "/" || operation == "%"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let historyView = segue.destination as! HistoryViewController
        historyView.historyBank = historyBank
    }

}

