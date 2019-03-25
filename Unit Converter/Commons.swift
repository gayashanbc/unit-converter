//
//  Commons.swift
//  Unit Converter
//
//  Created by Gayashan Bombuwala on 3/24/19.
//  Copyright © 2019 Gayashan Bombuwala. All rights reserved.
//

import UIKit

enum Metrics: Int {
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
 This protocol should be adapted by each metric enum
 */
protocol MetricsEnum {
    func getConversionRateToDefaultScale() -> Double
    func toString(_ value: Double) -> String
}

/*
 Common code segments used by several classes in the project
 */
class Utilities {
    static let buttonSelectedColor = UIColor(red:0.03, green:0.27, blue:0.44, alpha:1.0)
    static let buttonDeselectedColor = UIColor(red:0.06, green:0.04, blue:0.24, alpha:1.0)
    
    // Round-up a double value to 4 decimal places and returns string
    static func roundValue(_ valueToRound: Double) -> String {
        return String(round(10000 * valueToRound) / 10000)
    }
    
    // Remove the decimal places if there's only one trailing decimal zero [5.0 grams to 5 grams]
    static func removeSingleTrailingZero(from: Double) -> String {
        let numericPieces = String(from).components(separatedBy: ".")
        return numericPieces.last == "0" ? numericPieces.first! : numericPieces.joined(separator: ".")
    }
    
    // Convert seomething like 1 kilograms to 1 kilogram
    static func getStringSuffixForMetric (_ value: Double, suffixFraction:String = "s") -> String {
        return value != 1.0 ? suffixFraction : ""
    }
}
