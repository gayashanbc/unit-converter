//
//  ViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/15/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum KeyboardButton: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine, period, delete, negation
}

class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabBarButtons: [UIButton]!
    @IBOutlet weak var negateButton: UIButton!
    
    var weightViewController: UIViewController!
    var tabBarViewControllers: [UIViewController]!
    var selectedIndex = 0
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let weightViewController = storyboard.instantiateViewController(withIdentifier: "WeightViewController") as? WeightsViewController {
            weightViewController.parentControllerReference = self
            tabBarViewControllers = [weightViewController]
            
            tabBarButtons[selectedIndex].isSelected = true
        }
        //        weightViewController = storyboard.instantiateViewController(withIdentifier: "WeightViewController")
        //
        //        tabBarViewControllers = [weightViewController]
        //
        //        tabBarButtons[selectedIndex].isSelected = true
        if selectedIndex == 0 { // TODO chech if temperature is selected
            negateButton.isEnabled = false
        }
        didPressTab(tabBarButtons[selectedIndex])
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        tabBarButtons[previousIndex].isSelected = false
        
        let previousViewController = tabBarViewControllers[previousIndex]
        
        previousViewController.willMove(toParent: nil)
        previousViewController.view.removeFromSuperview()
        previousViewController.removeFromParent()
        
        sender.isSelected = true
        
        let newViewController = tabBarViewControllers[selectedIndex]
        
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
                currentText.insert("-", at: currentText.index(currentText.startIndex, offsetBy: 0))
                self.activeTextField.text = currentText
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
            
            if let position = activeTextField.position(from: selectedRange.start, offset: +1) {
                nextPosition = position
            }
            
            print("Current cursor position: \(currentPosition)")
            print("Next cursor position: \(nextPosition)")
        }
        
        return (currentPosition, nextPosition)
    }
    
    
}

