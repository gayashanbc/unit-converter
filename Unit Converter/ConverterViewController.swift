//
//  ConverterViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/15/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum KeyboardButton: Int { // Represents all the buttons in the custom keyboard
    case zero, one, two, three, four, five, six, seven, eight, nine, period, delete, negation
}

class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabBarButtons: [UIButton]!
    @IBOutlet weak var negateButton: UIButton!
    
    var tabBarViewControllers: [UIViewController]!
    var selectedTabIndex = 0
    var activeTextField = UITextField() // text field with active text focus
    var saveFunctions: [() -> Void]! // holds history save functions of each metric converter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let weightsViewController = storyboard.instantiateViewController(withIdentifier: "WeightsViewController") as? WeightsViewController else {return}
        guard let tempsViewController = storyboard.instantiateViewController(withIdentifier: "TempsViewController") as? TempsViewController else {return}
        guard let lengthsViewController = storyboard.instantiateViewController(withIdentifier: "LengthsViewController") as? LengthsViewController else {return}
        guard let speedsViewController = storyboard.instantiateViewController(withIdentifier: "SpeedsViewController") as? SpeedsViewController else {return}
        guard let volumesViewController = storyboard.instantiateViewController(withIdentifier: "VolumesViewController") as? VolumesViewController else {return}
        
        tabBarViewControllers = [weightsViewController, tempsViewController, lengthsViewController, speedsViewController, volumesViewController]
        saveFunctions = [weightsViewController.saveConversion, tempsViewController.saveConversion, lengthsViewController.saveConversion, speedsViewController.saveConversion, volumesViewController.saveConversion]
        
        weightsViewController.parentControllerReference = self
        tempsViewController.parentControllerReference = self
        lengthsViewController.parentControllerReference = self
        speedsViewController.parentControllerReference = self
        volumesViewController.parentControllerReference = self
        
        didPressTab(tabBarButtons[selectedTabIndex])
    }
    
    /*
    Handles tab navigation
    */
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedTabIndex
        
        selectedTabIndex = sender.tag
        tabBarButtons[previousIndex].backgroundColor = Utilities.buttonDeselectedColor
        negateButton.isEnabled = selectedTabIndex != 1 ? false : true // Only enable negation button for Temperature
        
        let previousViewController = tabBarViewControllers[previousIndex]
        
        // Remove previous viewController from the contentView
        previousViewController.willMove(toParent: nil)
        previousViewController.view.removeFromSuperview()
        previousViewController.removeFromParent()
        
        sender.backgroundColor = Utilities.buttonSelectedColor
        self.title = "\(Metrics(rawValue: selectedTabIndex)?.toString() ?? "") Converter"
        
        let newViewController = tabBarViewControllers[selectedTabIndex]
        
        // Add next viewController to the contentView
        addChild(newViewController)
        newViewController.view.frame = contentView.bounds
        contentView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        setKeyValueToTextField(pressedButton: KeyboardButton(rawValue: sender.tag)!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    @IBAction func constantsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "constantsViewSegue", sender: self)
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "historyViewSegue", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveFunctions[selectedTabIndex]() // Invoke the save function of the active metric converter
    }
    
    /*
    Inserts the pressed button value of the custom keyboard to the active text field
    */
    func setKeyValueToTextField(pressedButton: KeyboardButton) {
        let cursorPosition = getCursorPositions()
        
        if var currentText = self.activeTextField.text {
            switch pressedButton {
            case .delete:
                if(currentText.count > 0){ // TODO: add to enum
                    currentText.remove(at: currentText.index(currentText.startIndex, offsetBy: cursorPosition.current - 1))
                    self.activeTextField.text = currentText
                }
            case .negation:
                if(!currentText.contains("-")){
                    activeTextField.text?.insert("-", at: currentText.index(currentText.startIndex, offsetBy: 0))
                }

            case .period:
                if(!currentText.contains(".")){
                    activeTextField.insertText(".")
                    if(currentText.count > 1){ // TODO: add to enum
                        activeTextField.selectedTextRange = activeTextField.textRange(from: cursorPosition.next, to: cursorPosition.next)
                    }
                }
            default:
                activeTextField.insertText(String(pressedButton.rawValue))
                if(currentText.count > 1){ // TODO: add to enum
                    activeTextField.selectedTextRange = activeTextField.textRange(from: cursorPosition.next, to: cursorPosition.next)
                }
            }
            return;
        }
    }
    
    /*
    Returns the current cursor position and the next cursor position
    */
    func getCursorPositions() -> (current: Int, next: UITextPosition)  {
        var currentPosition = 0
        var nextPosition = activeTextField.beginningOfDocument
        
        if let selectedRange = activeTextField.selectedTextRange {
            currentPosition = activeTextField.offset(from: activeTextField.beginningOfDocument, to: selectedRange.start)
            
            if let position = activeTextField.position(from: selectedRange.start, offset: 1) {
                nextPosition = position
            }
            // TODO: remove following
            print("Current cursor position: \(currentPosition)")
            print("Next cursor position: \(nextPosition)")
        }
        
        return (currentPosition, nextPosition)
    }
    
}

