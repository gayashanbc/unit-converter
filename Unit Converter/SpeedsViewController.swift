//
//  SpeedsViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum SpeedMetrics: Int, MetricsEnum {
    case metresPerSec, kmPerHour, milesPerHour, knot
    
    func getConversionRateToDefaultScale() -> Double {
        switch self {
        case .kmPerHour:
            return 0.277778
        case .milesPerHour:
            return 0.44704
        case .knot:
            return 0.5144
        default: // Metres/sec
            return 1
        }
    }
    
    func toString(_ value: Double) -> String {
        let suffix = Utilities.getStringSuffixForMetric(value)
        let stringValue = Utilities.removeSingleTrailingZero(from: value)
        
        switch self {
        case .metresPerSec:
            return "\(stringValue) metre\(suffix)/s"
        case .kmPerHour:
            return "\(stringValue) km/h"
        case .milesPerHour:
            return "\(stringValue) mph"
        case .knot:
            return "\(stringValue) knot\(suffix)"
        }
    }
}

class SpeedsViewController: UnitConvesionController {
    @IBOutlet weak var metresTextField: UITextField!
    @IBOutlet weak var kmTextField: UITextField!
    @IBOutlet weak var milesTextField: UITextField!
    @IBOutlet weak var nauticalMilesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [metresTextField, kmTextField, milesTextField, nauticalMilesTextField]
        historyKey = "speedsHistory"
        assignDelegatesToTextFields()
    }
    
    @IBAction override func textFieldEditingChanged(_ sender: UITextField) {
        super.textFieldEditingChanged(sender)
    }
    
    override func getConversionRateToDefaultScale(forScaleID: Int) -> Double {
        return (SpeedMetrics(rawValue: forScaleID)?.getConversionRateToDefaultScale())!
    }
    
    override func getAsString(forValue: Double, scaleID: Int) -> String {
        return (SpeedMetrics(rawValue: scaleID)?.toString(forValue))!
    }
    
}
