//
//  ConverterViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/15/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum KeyboardButton: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine, period, delete, negation
}

enum Metrics: Int{
    case Weight, Temperature, Length, Speed, Volume
    
    func toString() -> String {
        switch self {
        case .Weight:
            return "Weight Converter"
        case .Temperature:
            return "Temperature Converter"
        case .Length:
            return "Length Converter"
        case .Speed:
            return "Speed Converter"
        case .Volume:
            return "Volume Converter"
        }
    }
}

class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabBarButtons: [UIButton]!
    @IBOutlet weak var negateButton: UIButton!
    
    var tabBarViewControllers: [UIViewController]!
    var selectedTabIndex = 0
    var activeTextField = UITextField()
    var saveFunctions: [() -> Void]!
    
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
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedTabIndex
        
        selectedTabIndex = sender.tag
        tabBarButtons[previousIndex].backgroundColor = Utilities.buttonDeselectedColor
        negateButton.isEnabled = selectedTabIndex != 1 ? false : true // Only enable negation button for Temperature
        
        let previousViewController = tabBarViewControllers[previousIndex]
        
        previousViewController.willMove(toParent: nil)
        previousViewController.view.removeFromSuperview()
        previousViewController.removeFromParent()
        
        sender.backgroundColor = Utilities.buttonSelectedColor
        self.title = Metrics(rawValue: selectedTabIndex)?.toString()
        
        let newViewController = tabBarViewControllers[selectedTabIndex]
        
        addChild(newViewController)
        newViewController.view.frame = contentView.bounds
        contentView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        setKeyValueToTextField(pressedButton: KeyboardButton(rawValue: sender.tag)!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    @IBAction func constantsButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "weightsHistory") // TODO: remove
        performSegue(withIdentifier: "constantsViewSegue", sender: self)
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        print(UserDefaults.standard.array(forKey: "weightsHistory") ?? []) // TODO: remove
        performSegue(withIdentifier: "historyViewSegue", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveFunctions[selectedTabIndex]()
    }
    
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

