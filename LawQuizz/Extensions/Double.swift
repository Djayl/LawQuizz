//
//  Double.swift
//  LawQuizz
//
//  Created by MacBook DS on 06/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

extension Double {
    // MARK: Method that rounds a Double
    var round: String {
        return String(format: "%2g", self)
    }
    
    func truncateDigitsAfterDecimal(number: Double, afterDecimalDigits: Int) -> Double {
       if afterDecimalDigits < 1 || afterDecimalDigits > 512 {return 0.0}
       return Double(String(format: "%.\(afterDecimalDigits)f", number))!
    }
}
