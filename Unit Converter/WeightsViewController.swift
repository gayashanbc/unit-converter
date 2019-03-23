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
    
    func toString(_ value: Double) -> String {
        let suffix = value != 1.0 ? "s" : "" // TODO: replace value with a constant
        
        switch self {
        case .ounce:
            return "\(value) ounce\(suffix)"
        case .pound:
            return "\(value) pound\(suffix)"
        case .gram:
            return "\(value) gram\(suffix)"
        case .stone:
            return "\(value) stone\(suffix)"
        case .kg:
            return "\(value) kilogram\(suffix)"
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
                textField.text = Utilities.roundValue(enteredValueInKg / conversionRateToKg)
            }
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        var history = UserDefaults.standard.array(forKey: "weightsHistory") ?? []
        
        for textField in textFields {
            guard let text = textField.text else {return}
            
            if let numericValue = Double(text), let conversionValue = WeightMetrics(rawValue: textField.tag)?.toString(numericValue) {
                historyString += "\(conversionValue)\(textField != textFields.last ? "\n" : "")"
            }
        }
        
        
        if history.count == 5 { // TODO: replace value with a constant
            history.remove(at: 4) // TODO: replace value with a constant
        }
        history.insert(historyString, at: 0) // TODO: replace value with a constant
        UserDefaults.standard.set(history, forKey: "weightsHistory")
    }
    
    
}
