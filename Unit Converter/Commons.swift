//
//  Commons.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import Foundation

protocol SaveableConversion {
    var topHistoryElement: Int {get}
    var lastHistoryElement: Int {get}
    var maxHistorySize: Int {get}
    var historyKey: String {get}
    
    func saveConversion()
}

class Utilities {
    static func roundValue(_ valueToRound: Double) -> String {
        var roundedValue = String(round(10000 * valueToRound) / 10000)
        if let trailingZeros = roundedValue.components(separatedBy: ".").last?.count {
            switch trailingZeros {
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
