//
//  TempsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum TemperatureMetrics: Int {
    case celsius, farenheit, kelvin
    
    func convertToKelvin(_ fromValue: Double) -> Double {
        switch self {
        case .celsius:
            return fromValue + 273.15
        case .farenheit:
            return (((fromValue - 32) * 5) / 9) + 273.15
        default:
            return fromValue
        }
    }
    
    func convertToOtherScale(_ fromValue: Double) -> Double {
        switch self {
        case .celsius:
            return fromValue - 273.15
        case .farenheit:
            return ((fromValue - 273.15) * 9 / 5) + 32
        default:
            return fromValue
        }
    }
    
    func toString(_ value: Double) -> String {
        let numericPieces = String(value).components(separatedBy: ".")
        let stringValue = numericPieces.last == "0" ? numericPieces.first : numericPieces.joined(separator: ".")
        
        switch self {
        case .celsius:
            return "\(stringValue!) celsius"
        case .farenheit:
            return "\(stringValue!) farenheit"
        case .kelvin:
            return "\(stringValue!) kelvin"
        }
    }
}

class TempsViewController: UIViewController, UITextFieldDelegate, MetricConverter {
    @IBOutlet weak var celsiusTextField: UITextField!
    @IBOutlet weak var farenheitTextField: UITextField!
    @IBOutlet weak var kelvinTextField: UITextField!
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5, historyKey = "tempsHistory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        celsiusTextField.delegate = parentControllerReference
        farenheitTextField.delegate = parentControllerReference
        kelvinTextField.delegate = parentControllerReference
        
        textFields = [celsiusTextField, farenheitTextField, kelvinTextField]
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let enteredValueInKelvin = TemperatureMetrics(rawValue: sender.tag)?.convertToKelvin(enteredNumValue) else {return}
        
        
        for textField in textFields {
            if let convertedScaleValue = TemperatureMetrics(rawValue: textField.tag)?.convertToOtherScale(enteredValueInKelvin){
                textField.text = Utilities.roundValue(convertedScaleValue)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: historyKey) ?? []
        
        for textField in textFields {
            guard let text = textField.text else {return}
            
            if let numericValue = Double(text), let conversionValue = TemperatureMetrics(rawValue: textField.tag)?.toString(numericValue) {
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
