//
//  WeightsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/16/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum WeightMetrics: Int, MetricsEnum {
    case ounce, pound, gram, stone, kg
    
    func getConversionRateToDefaultScale() -> Double {
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
        let suffix = Utilities.getStringSuffixForMetric(value)
        let stringValue = Utilities.removeSingleTrailingZero(from: value)
        
        switch self {
        case .ounce:
            return "\(stringValue) ounce\(suffix)"
        case .pound:
            return "\(stringValue) pound\(suffix)"
        case .gram:
            return "\(stringValue) gram\(suffix)"
        case .stone:
            return "\(stringValue) stone\(suffix)"
        case .kg:
            return "\(stringValue) kilogram\(suffix)"
        }
    }
}


class WeightsViewController: UnitConvesionController {
    
    @IBOutlet weak var ounceTextField: UITextField!
    @IBOutlet weak var poundTextField: UITextField!
    @IBOutlet weak var gramTextField: UITextField!
    @IBOutlet weak var stoneTextField: UITextField!
    @IBOutlet weak var kgTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [ounceTextField, poundTextField, gramTextField, stoneTextField, kgTextField]
        historyKey = "weightsHistory"
        assignDelegatesToTextFields()
    }
    
    @IBAction override func textFieldEditingChanged(_ sender: UITextField) {
        super.textFieldEditingChanged(sender)
    }
    
    override func getConversionRateToDefaultScale(forScaleID: Int) -> Double {
        return (WeightMetrics(rawValue: forScaleID)?.getConversionRateToDefaultScale())!
    }
    
    override func getAsString(forValue: Double, scaleID: Int) -> String {
        return (WeightMetrics(rawValue: scaleID)?.toString(forValue))!
    }
    
}
