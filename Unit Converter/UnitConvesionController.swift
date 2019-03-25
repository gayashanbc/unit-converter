//
//  UnitConvesionController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/25/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

// This is the base class of all unit conversion viewControllers
class UnitConvesionController: UIViewController, UITextFieldDelegate {
    
    var textFields: [UITextField]!
    var parentControllerReference: UITextFieldDelegate?
    
    let topHistoryElement = 0, lastHistoryElement = 4, maxHistorySize = 5
    var historyKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Assign parentControllerReference as the textField delegate of all the textFields
    func assignDelegatesToTextFields (){
        for textField in textFields {
            textField.delegate = parentControllerReference
        }
    }
    
    // Return the conversion rate to the default scale of the relevant metric enum
    // Must be overridden in each sub-class
    func getConversionRateToDefaultScale(forScaleID: Int) -> Double {
        preconditionFailure("This method must be overridden")
    }
    
    // Return the string representation of given value, with regards to the relevant metric enum
    // Must be overridden in each sub-class
    func getAsString (forValue: Double, scaleID: Int) -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func textFieldEditingChanged(_ sender: UITextField) {
        // Return if the textfield is empty
        guard let textFieldValue = sender.text else {return}
        guard let enteredNumValue = Double(textFieldValue) else {return}
        
        // Get base conversion rate to the default metric (i.e. Kilograms) based in the textfield tag
        let baseConversionRate = getConversionRateToDefaultScale(forScaleID: sender.tag)
        
        // Convert the conversion value to the dafault metric (i.e. Kilograms)
        let enteredValueInDefaultScale = enteredNumValue * baseConversionRate
        
        // Calculate conversion values for all other metrics
        for textField in textFields {
            textField.text = Utilities.roundValue(enteredValueInDefaultScale / getConversionRateToDefaultScale(forScaleID: textField.tag) )
        }
    }
    
    func saveConversion()  {
        var historyString: String = ""
        guard let accessKey = historyKey else {return}
        var history = UserDefaults.standard.array(forKey: accessKey) ?? [] // Create a history array if doesn't exist
        
        for textField in textFields { // Create a concatenated history string
            guard let text = textField.text else {return} // Skip textfeilds without values
            
            if let numericValue = Double(text) {
                // Append a new line to each conversion value, except the last line
                historyString += "\(getAsString(forValue: numericValue, scaleID: textField.tag) )\(textField != textFields.last ? "\n" : "" )"
            }
        }
        
        if historyString != "" { // Ensure that there is at least one conversion to be saved
            if history.count == maxHistorySize { // Remove the olderst element when the capacity exceeds
                history.remove(at: lastHistoryElement)
            }
            
            history.insert(historyString, at: topHistoryElement) // This will show the latest conversion at the top
            UserDefaults.standard.set(history, forKey: accessKey)
        }
        
    }
    
}
