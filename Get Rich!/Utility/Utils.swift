//
//   Utils.swift
//   ForSale
//
//  Created by: CSC214 Instructor on 11/12/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//

import Foundation

func formatAsCurrency(_ price: Double?) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: price ?? 0.0)) ?? ""
}

func formatAsCurrencyNoCommas(_ price: Double?) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: price ?? 0.0)) ?? ""
}
