//
//  HistoryViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/23/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tabBarButtons: [UIButton]!
    
    var selectedTabIndex = 0
    var history: [String]!
    var historyAccessKeys = ["weightsHistory", "tempsHistory", "lengthsHistory", "speedsHistory", "volumesHistory"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.allowsSelection = false
        didPressTab(tabBarButtons[selectedTabIndex])
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedTabIndex
        
        selectedTabIndex = sender.tag
        tabBarButtons[previousIndex].backgroundColor = Utilities.buttonDeselectedColor
        
        history = UserDefaults.standard.array(forKey: historyAccessKeys[selectedTabIndex]) as? [String] ?? []
        tableView.reloadData()
        
        sender.backgroundColor = Utilities.buttonSelectedColor
        self.title = "\(Metrics(rawValue: selectedTabIndex)?.toString() ?? "")s History"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableHistoryCell")!
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0 // Unlimited number of lines
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
}
