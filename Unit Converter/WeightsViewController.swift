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
        default:
            return 1
        }
    }
}

class WeightsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ounceTextField: UITextField!
    @IBOutlet weak var poundTextField: UITextField!
    @IBOutlet weak var gramTextField: UITextField!
    @IBOutlet weak var stoneTextField: UITextField!
    @IBOutlet weak var kgTextField: UITextField!
    
    var textFields: [UITextField]!
    
    var parentControllerReference: UITextFieldDelegate?
    
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
        print("Eidted \(sender.tag)")
        print("Conversin rate: \(WeightMetrics.ounce.getConversionRateToKg())")
        
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        guard let baseConversionRate = WeightMetrics(rawValue: sender.tag)?.getConversionRateToKg() else {return}
        
        let enteredValueInKg = enteredNumValue * baseConversionRate
        print("Kg Value: \(enteredValueInKg)")
        
        for textField in textFields {
            if let conversionRateToKg = WeightMetrics(rawValue: textField.tag)?.getConversionRateToKg(){
                textField.text = roundValue(enteredValueInKg / conversionRateToKg)
            }
        }
    }
    
    func roundValue(_ valueToRound: Double) -> String {
        var roundedValue = String(round(10000 * valueToRound) / 10000)
        if let trailingZeros = roundedValue.components(separatedBy: ".").last?.count {
            switch trailingZeros {
            case 1:
                roundedValue += "000"
            case 2:
                roundedValue += "00"
            case 3:
                roundedValue += "0"
            default:
                break
            }
        }
        return roundedValue
    }
    
    
}
