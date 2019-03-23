//
//  HistoryViewController.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/23/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {
    
    var history: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Customize the following code for each metric
        history = UserDefaults.standard.array(forKey: "weightsHistory") as? [String] ?? []
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
