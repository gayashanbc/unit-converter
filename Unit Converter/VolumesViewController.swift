//
//  VolumesViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum VolumeMetrics: Int, MetricsEnum {
    case gallon, litre, ukPint, fluidOunce, millilitre
    
    func getConversionRateToDefaultScale() -> Double {
        switch self {
        case .gallon:
            return 4.54609
        case .ukPint:
            return 0.568261
        case .fluidOunce:
            return 0.0284131
        case .millilitre:
            return 0.001
        default: // Litre
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = Utilities.getStringSuffixForMetric(value)
        let stringValue = Utilities.removeSingleTrailingZero(from: value)
        
        switch self {
        case .gallon:
            return "\(stringValue) gallon\(suffix)"
        case .litre:
            return "\(stringValue) litre\(suffix)"
        case .ukPint:
            return "\(stringValue) UK pint\(suffix)"
        case .fluidOunce:
            return "\(stringValue) fluid ounce\(suffix)"
        case .millilitre:
            return "\(stringValue) millilitre\(suffix)"
        }
    }
}

class VolumesViewController: UnitConvesionController {
    @IBOutlet weak var gallonTextField: UITextField!
    @IBOutlet weak var litreTextField: UITextField!
    @IBOutlet weak var pintTextField: UITextField!
    @IBOutlet weak var fluidOunceTextField: UITextField!
    @IBOutlet weak var millilitreTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [gallonTextField, litreTextField, pintTextField, fluidOunceTextField, millilitreTextField]
        historyKey = "volumesHistory"
        assignDelegatesToTextFields()
    }
    
    @IBAction override func textFieldEditingChanged(_ sender: UITextField) {
        super.textFieldEditingChanged(sender)
    }
    
    override func getConversionRateToDefaultScale(forScaleID: Int) -> Double {
        return (VolumeMetrics(rawValue: forScaleID)?.getConversionRateToDefaultScale())!
    }
    
    override func getAsString(forValue: Double, scaleID: Int) -> String {
        return (VolumeMetrics(rawValue: scaleID)?.toString(forValue))!
    }
    
}
