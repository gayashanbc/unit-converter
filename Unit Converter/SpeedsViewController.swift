//
//  SpeedsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum SpeedMetrics: Int {
    case metresPerSec, kmPerHour, milesPerHour, knot
    
    func getConversionRateToMetresSec() -> Double {
        switch self {
        case .kmPerHour:
            return 0.277778
        case .milesPerHour:
            return 0.44704
        case .knot:
            return 0.5144
        default:
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = value != 1.0 ? "s" : ""
        
        let numericPieces = String(value).components(separatedBy: ".")
        let stringValue = numericPieces.last == "0" ? numericPieces.first : numericPieces.joined(separator: ".")
        
        switch self {
        case .metresPerSec:
            return "\(stringValue!) metre\(suffix)/s"
        case .kmPerHour:
            return "\(stringValue!) km/h"
        case .milesPerHour:
            return "\(stringValue!) mph"
        case .knot:
            return "\(stringValue!) knot\(suffix)"
        }
    }
}

class SpeedsViewController: UIViewController, UITextFieldDelegate, MetricConverter {
    @IBOutlet weak var metresTextField: UITextField!
    @IBOutlet weak var kmTextField: UITextField!
    @IBOutlet weak var milesTextField: UITextField!
    @IBOutlet weak var nauticalMilesTextField: UITextField!
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5, historyKey = "speedsHistory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metresTextField.delegate = parentControllerReference
        kmTextField.delegate = parentControllerReference
        milesTextField.delegate = parentControllerReference
        nauticalMilesTextField.delegate = parentControllerReference
        
        textFields = [metresTextField, kmTextField, milesTextField, nauticalMilesTextField]
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let baseConversionRate = SpeedMetrics(rawValue: sender.tag)?.getConversionRateToMetresSec() else {return}
        
        let enteredValueInKg = enteredNumValue * baseConversionRate
        
        for textField in textFields {
            if let conversionRateToKg = SpeedMetrics(rawValue: textField.tag)?.getConversionRateToMetresSec(){
                textField.text = Utilities.roundValue(enteredValueInKg / conversionRateToKg)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: historyKey) ?? []
        
        for textField in textFields {
            guard let text = textField.text else {return}
            
            if let numericValue = Double(text), let conversionValue = SpeedMetrics(rawValue: textField.tag)?.toString(numericValue) {
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
