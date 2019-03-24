//
//  LengthsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum LengthMetrics: Int {
    case metre, mile, cm, mm, yard, inch
    
    func getConversionRateToMetres() -> Double {
        switch self {
        case .mile:
            return 1609.344
        case .mm:
            return 0.001
        case .cm:
            return 0.01
        case .yard:
            return 0.9144
        case .inch:
            return 0.0254
        default:
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = value != 1.0 ? "s" : ""
        
        let numericPieces = String(value).components(separatedBy: ".")
        let stringValue = numericPieces.last == "0" ? numericPieces.first : numericPieces.joined(separator: ".")
        
        switch self {
        case .metre:
            return "\(stringValue!) metre\(suffix)"
        case .mile:
            return "\(stringValue!) mile\(suffix)"
        case .mm:
            return "\(stringValue!) millimetre\(suffix)"
        case .cm:
            return "\(stringValue!) centimetre\(suffix)"
        case .yard:
            return "\(stringValue!) yard\(suffix)"
        case .inch:
            return "\(stringValue!) inch\(value != 1.0 ? "es" : "")"
        }
    }
}

class LengthsViewController: UIViewController, UITextFieldDelegate, MetricConverter  {
    @IBOutlet weak var metreTextField: UITextField!
    @IBOutlet weak var mileTextField: UITextField!
    @IBOutlet weak var cmTextField: UITextField!
    @IBOutlet weak var mmTextField: UITextField!
    @IBOutlet weak var yardTextField: UITextField!
    @IBOutlet weak var inchTextField: UITextField!
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5, historyKey = "lengthsHistory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metreTextField.delegate = parentControllerReference
        mileTextField.delegate = parentControllerReference
        cmTextField.delegate = parentControllerReference
        mmTextField.delegate = parentControllerReference
        yardTextField.delegate = parentControllerReference
        inchTextField.delegate = parentControllerReference
        
        textFields = [metreTextField, mileTextField, cmTextField, mmTextField, yardTextField, inchTextField]
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let baseConversionRate = LengthMetrics(rawValue: sender.tag)?.getConversionRateToMetres() else {return}
        
        let enteredValueInMetres = enteredNumValue * baseConversionRate
        
        for textField in textFields {
            if let conversionRateToKg = LengthMetrics(rawValue: textField.tag)?.getConversionRateToMetres(){
                textField.text = Utilities.roundValue(enteredValueInMetres / conversionRateToKg)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: historyKey) ?? []
        
        for textField in textFields {
            guard let text = textField.text else {return}
            
            if let numericValue = Double(text), let conversionValue = LengthMetrics(rawValue: textField.tag)?.toString(numericValue) {
                historyString += "\(conversionValue)\(textField != textFields.last ? "\n" : "" )"
            }
        }
        
        if historyString != "" {
            if history.count == maxHistorySize {
                history.remove(at: lastHistoryElement)
            }
            
            history.insert(historyString, at: topHistoryElement)
            UserDefaults.standard.set(history, forKey: historyKey)
        }
        
    }

}
