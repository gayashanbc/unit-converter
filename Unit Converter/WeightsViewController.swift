//
//  WeightsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/16/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum WeightMetrics: Int {
    case ounce, pound, gram, stone, kg
    
    func getConversionRateToKg() -> Double {
        switch self {
        case .ounce:
            return 0.02834952
        case .pound:
            return 0.4535923
        case .gram:
            return 0.001000000
        case .stone:
            return 6.350293
        default: // value of the default SI metric for weights [i.e. kilogram for weights]
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = value != 1.0 ? "s" : "" // Convert seomething like 1 kilograms to 1 kilogram
        
        // Remove the decimal places if there's only one trailing decimal zero [5.0 grams to 5 grams]
        let numericPieces = String(value).components(separatedBy: ".")
        let stringValue = numericPieces.last == "0" ? numericPieces.first : numericPieces.joined(separator: ".")
        
        switch self {
        case .ounce:
            return "\(stringValue!) ounce\(suffix)"
        case .pound:
            return "\(stringValue!) pound\(suffix)"
        case .gram:
            return "\(stringValue!) gram\(suffix)"
        case .stone:
            return "\(stringValue!) stone\(suffix)"
        case .kg:
            return "\(stringValue!) kilogram\(suffix)"
        }
    }
}


class WeightsViewController: UIViewController, UITextFieldDelegate, MetricConverter {
    
    @IBOutlet weak var ounceTextField: UITextField!
    @IBOutlet weak var poundTextField: UITextField!
    @IBOutlet weak var gramTextField: UITextField!
    @IBOutlet weak var stoneTextField: UITextField!
    @IBOutlet weak var kgTextField: UITextField!
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5, historyKey = "weightsHistory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ounceTextField.delegate = parentControllerReference
        poundTextField.delegate = parentControllerReference
        gramTextField.delegate = parentControllerReference
        stoneTextField.delegate = parentControllerReference
        kgTextField.delegate = parentControllerReference
        
        textFields = [ounceTextField, poundTextField, gramTextField, stoneTextField, kgTextField]
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        // Return if the textfield is empty
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        
        // Get base conversion rate to the default metric (i.e. Kilograms) based in the textfield tag
        guard let baseConversionRate = WeightMetrics(rawValue: sender.tag)?.getConversionRateToKg() else {return}
        
        // Convert the conversion value to the dafault metric (i.e. Kilograms)
        let enteredValueInKg = enteredNumValue * baseConversionRate
        
        // Calculate conversion values for all other metrics
        for textField in textFields {
            if let conversionRateToKg = WeightMetrics(rawValue: textField.tag)?.getConversionRateToKg(){
                textField.text = Utilities.roundValue(enteredValueInKg / conversionRateToKg)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: historyKey) ?? [] // Create a history array if doesn't exist
        
        for textField in textFields { // Create a concatenated history string
            guard let text = textField.text else {return} // Skip textfeilds without values
            
            if let numericValue = Double(text), let conversionValue = WeightMetrics(rawValue: textField.tag)?.toString(numericValue) {
                
                // Append a new line to each conversion value, except the last line
                historyString += "\(conversionValue)\(textField != textFields.last ? "\n" : "" )"
            }
        }
        
        if historyString != "" { // Ensure that there is at least one conversion to be saved
            if history.count == maxHistorySize { // Remove the olderst element when the capacity exceeds
                history.remove(at: lastHistoryElement)
            }
            
            history.insert(historyString, at: topHistoryElement) // This will show the latest conversion at the top
            UserDefaults.standard.set(history, forKey: historyKey)
        }
        
    }
    
}
