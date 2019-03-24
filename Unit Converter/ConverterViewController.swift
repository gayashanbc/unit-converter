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
        let cursorPosition = getCursorPosition()
        
        if let currentText = self.activeTextField.text {
            switch pressedButton {
            case .delete:
                if currentText.count != 0 { // Ensure that there is at least one character to be deleted
                    self.activeTextField.text?.remove(at: currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1))
                    
                    // Ensure the editing changed event is only fired when not deleting a period
                    // This will stop getting a new period added automatically when the current period is deleted
                    if String(currentText[currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1)]) != "." {
                        activeTextField.sendActions(for: UIControl.Event.editingChanged)
                    }
                    setCursorPosition(from: cursorPosition, offset: -1)
                }
            case .negation:
                if !currentText.contains("-"), currentText.count != 0 { // Avoid double and empty insertions of negaation
                    activeTextField.text?.insert("-", at: currentText.index(currentText.startIndex, offsetBy: 0))
                    activeTextField.sendActions(for: UIControl.Event.editingChanged) // Raise the textEditingChangedEvent
                    setCursorPosition(from: cursorPosition)
                }
                
            case .period:
                if !currentText.contains("."), currentText.count != 0 { // Avoid double and empty insertions of period
                    activeTextField.insertText(".")
                    setCursorPosition(from: cursorPosition)
                }
            default:
                activeTextField.insertText(String(pressedButton.rawValue))
                setCursorPosition(from: cursorPosition)
            }
            return;
        }
    }
    
    /*
     Return the current cursor position
     */
    func getCursorPosition() -> Int {
        guard let selectedRange = activeTextField.selectedTextRange else {return 0}
        return activeTextField.offset(from: activeTextField.beginningOfDocument, to: selectedRange.start)
    }
    
    /*
     Set the cursor position to the optionally specified position: default to the right of the current position
     */
    func setCursorPosition(from:Int, offset: Int = 1) {
        if let newPosition = activeTextField.position(from: activeTextField.beginningOfDocument, offset: from + offset) {
            activeTextField.selectedTextRange = activeTextField.textRange(from: newPosition, to: newPosition)
        }
    }
    
}

