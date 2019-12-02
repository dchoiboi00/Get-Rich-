//
//  Stock.swift
//  Stox
//
//  Created by CSC214 Instructor on 11/11/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//

import Foundation

class Profile: Decodable {
    var price: Double
    var beta: String
    var volAvg: String
    var mktCap: String
    var lastDiv: String
    var range: String
    var changes: Double
    var changesPercentage: String
    var companyName: String
    var exchange: String
    var industry: String
    var website: String
    var description: String
    var ceo: String
    var sector: String
    var image: String
}

enum CodingKeys: String, CodingKey {
    case symbol
    case profile
}

class Stock: Decodable {
   
    var symbol: String?
    var profile: Profile?
    
    init() {
        symbol = "???"
        profile = nil
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        profile = try container.decode(Profile.self, forKey: .profile)
    }
}
