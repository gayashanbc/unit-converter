//
//  LengthsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum LengthMetrics: Int, MetricsEnum {
    case metre, mile, cm, mm, yard, inch
    
    func getConversionRateToDefaultScale() -> Double {
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
        default: // Metre
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = Utilities.getStringSuffixForMetric(value)
        let stringValue = Utilities.removeSingleTrailingZero(from: value)
        
        switch self {
        case .metre:
            return "\(stringValue) metre\(suffix)"
        case .mile:
            return "\(stringValue) mile\(suffix)"
        case .mm:
            return "\(stringValue) millimetre\(suffix)"
        case .cm:
            return "\(stringValue) centimetre\(suffix)"
        case .yard:
            return "\(stringValue) yard\(suffix)"
        case .inch:
            return "\(stringValue) inch\(Utilities.getStringSuffixForMetric(value, suffixFraction: "es"))"
        }
    }
}

class LengthsViewController: UnitConvesionController  {
    @IBOutlet weak var metreTextField: UITextField!
    @IBOutlet weak var mileTextField: UITextField!
    @IBOutlet weak var cmTextField: UITextField!
    @IBOutlet weak var mmTextField: UITextField!
    @IBOutlet weak var yardTextField: UITextField!
    @IBOutlet weak var inchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [metreTextField, mileTextField, cmTextField, mmTextField, yardTextField, inchTextField]
        historyKey = "lengthsHistory"
        assignDelegatesToTextFields()
    }
    
    @IBAction override func textFieldEditingChanged(_ sender: UITextField) {
        super.textFieldEditingChanged(sender)
    }
    
    override func getConversionRateToDefaultScale(forScaleID: Int) -> Double {
        return (LengthMetrics(rawValue: forScaleID)?.getConversionRateToDefaultScale())!
    }
    
    override func getAsString(forValue: Double, scaleID: Int) -> String {
        return (LengthMetrics(rawValue: scaleID)?.toString(forValue))!
    }
    
}
