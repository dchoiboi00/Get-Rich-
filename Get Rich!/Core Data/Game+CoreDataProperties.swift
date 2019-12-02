//
//  Game+CoreDataProperties.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/28/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var balance: Int16
    @NSManaged public var billSize: Int16
    @NSManaged public var multiplier: Int16
    @NSManaged public var investments: Int32
    @NSManaged public var motto: String?
    @NSManaged public var income: Int16

}
