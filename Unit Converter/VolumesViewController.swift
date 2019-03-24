//
//  VolumesViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum VolumeMetrics: Int {
    case gallon, litre, ukPint, fluidOunce, millilitre
    
    func getConversionRateToLitres() -> Double {
        switch self {
        case .gallon:
            return 4.54609
        case .ukPint:
            return 0.568261
        case .fluidOunce:
            return 0.0284131
        case .millilitre:
            return 0.001
        default:
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = value != 1.0 ? "s" : ""
        
        let numericPieces = String(value).components(separatedBy: ".")
        let stringValue = numericPieces.last == "0" ? numericPieces.first : numericPieces.joined(separator: ".")
        
        switch self {
        case .gallon:
            return "\(stringValue!) gallon\(suffix)"
        case .litre:
            return "\(stringValue!) litre\(suffix)"
        case .ukPint:
            return "\(stringValue!) UK pint\(suffix)"
        case .fluidOunce:
            return "\(stringValue!) fluid ounce\(suffix)"
        case .millilitre:
            return "\(stringValue!) millilitre\(suffix)"
        }
    }
}

class VolumesViewController: UIViewController, UITextFieldDelegate, MetricConverter  {
    @IBOutlet weak var gallonTextField: UITextField!
    @IBOutlet weak var litreTextField: UITextField!
    @IBOutlet weak var pintTextField: UITextField!
    @IBOutlet weak var fluidOunceTextField: UITextField!
    @IBOutlet weak var millilitreTextField: UITextField!
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5, historyKey = "volumesHistory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gallonTextField.delegate = parentControllerReference
        litreTextField.delegate = parentControllerReference
        pintTextField.delegate = parentControllerReference
        fluidOunceTextField.delegate = parentControllerReference
        millilitreTextField.delegate = parentControllerReference
        
        textFields = [gallonTextField, litreTextField, pintTextField, fluidOunceTextField, millilitreTextField]
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let baseConversionRate = VolumeMetrics(rawValue: sender.tag)?.getConversionRateToLitres() else {return}
        
        let enteredValueInLitres = enteredNumValue * baseConversionRate
        
        for textField in textFields {
            if let conversionRateToKg = VolumeMetrics(rawValue: textField.tag)?.getConversionRateToLitres(){
                textField.text = Utilities.roundValue(enteredValueInLitres / conversionRateToKg)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: historyKey) ?? []
        
        for textField in textFields {
            guard let text = textField.text else {return}
            
            if let numericValue = Double(text), let conversionValue = VolumeMetrics(rawValue: textField.tag)?.toString(numericValue) {
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
