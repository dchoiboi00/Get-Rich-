//
//  GameData.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/29/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import Foundation

struct Business {
    var perSwipe: Int
    var purchaseCost: Int
}

func determineInvestments(storedVal: Int) -> [Bool] {
    var boolArray = [false, false, false, false, false, false]
    var x = storedVal
    while (x > 0) {
        let num = x % 10
        let index = num - 1
        boolArray[index] = true
        x = x / 10
    }
    return boolArray
}

enum CurrencyType: Int {
    case USD, EUR, KRW, GBP
    static let allValues = [USD, EUR, KRW, GBP]
    
    func title() -> String {
        switch self {
        case .USD:
            return "US Dollars"
        case .EUR:
            return "Euro"
        case .KRW:
            return "Korean Won"
        case .GBP:
            return "UK Pounds"
        }
    }
    
    
}
