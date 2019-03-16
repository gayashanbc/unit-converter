//
//  ViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/15/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabBarButtons: [UIButton]!
    
    var weightViewController: UIViewController!
    var tabBarViewControllers: [UIViewController]!
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        weightViewController = storyboard.instantiateViewController(withIdentifier: "WeightViewController")
        tabBarViewControllers = [weightViewController]
        
        tabBarButtons[selectedIndex].isSelected = true
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
    
}

