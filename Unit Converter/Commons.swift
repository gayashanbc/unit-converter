//
//  Commons.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum Metrics: Int{
    case Weight, Temperature, Length, Speed, Volume
    
    func toString() -> String {
        switch self {
        case .Weight:
            return "Weight"
        case .Temperature:
            return "Temperature"
        case .Length:
            return "Length"
        case .Speed:
            return "Speed"
        case .Volume:
            return "Volume"
        }
    }
}

/*
 This protocol should be adapted by each metric converter class
 */
protocol MetricConverter {
    var parentControllerReference: UITextFieldDelegate? {get set} // required to assign the UITextFieldDelegate
    var topHistoryElement: Int {get}
    var lastHistoryElement: Int {get}
    var maxHistorySize: Int {get}
    var historyKey: String {get}
    
    func saveConversion()
}

/*
 Common code segments used by several classes in the project
 */
class Utilities {
    static let buttonSelectedColor = UIColor(red:0.03, green:0.27, blue:0.44, alpha:1.0)
    static let buttonDeselectedColor = UIColor(red:0.06, green:0.04, blue:0.24, alpha:1.0)
    
    static func roundValue(_ valueToRound: Double) -> String {
        var roundedValue = String(round(10000 * valueToRound) / 10000)
        if let trailingZeros = roundedValue.components(separatedBy: ".").last?.count {
            switch trailingZeros { // Add missing trailing zeros
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
