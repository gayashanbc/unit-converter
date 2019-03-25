//
//  TempsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum TemperatureMetrics: Int, MetricsEnum {
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
        let stringValue = Utilities.removeSingleTrailingZero(from: value)
        
        switch self {
        case .celsius:
            return "\(stringValue) celsius"
        case .farenheit:
            return "\(stringValue) farenheit"
        case .kelvin:
            return "\(stringValue) kelvin"
        }
    }
    
    // Exceptional situation
    func getConversionRateToDefaultScale() -> Double {return 0.0}
    
}

class TempsViewController: UnitConvesionController {
    @IBOutlet weak var celsiusTextField: UITextField!
    @IBOutlet weak var farenheitTextField: UITextField!
    @IBOutlet weak var kelvinTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [celsiusTextField, farenheitTextField, kelvinTextField]
        historyKey = "tempsHistory"
        assignDelegatesToTextFields()
    }
    
    @IBAction override func textFieldEditingChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let enteredValueInKelvin = TemperatureMetrics(rawValue: sender.tag)?.convertToKelvin(enteredNumValue) else {return}
        
        for textField in textFields {
            if let convertedScaleValue = TemperatureMetrics(rawValue: textField.tag)?.convertToOtherScale(enteredValueInKelvin){
                textField.text = Utilities.roundValue(convertedScaleValue)
            }
        }
    }
    
    override func getAsString(forValue: Double, scaleID: Int) -> String {
        return (TemperatureMetrics(rawValue: scaleID)?.toString(forValue))!
    }
    
    
}
