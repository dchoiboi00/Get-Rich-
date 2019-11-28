//
//  CoreDataStack.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/28/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    
    let modelName = "Get_Rich_"
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var Game: [NSManagedObject] = []
    
    // MARK: - Core Data operations
    
    func update() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
        do {
            Game = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
    }
    
    func initGame(balance: Int16, billSize: Int16, multiplier: Int16, investments: Int16, motto: String) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Game", in: context) {
            let game = NSManagedObject(entity: entity, insertInto: context)
            print("storing billsize as \(billSize)")
            game.setValue(balance, forKeyPath: "balance")
            game.setValue(billSize, forKeyPath: "billSize")
            game.setValue(multiplier, forKeyPath: "multiplier")
            game.setValue(investments, forKeyPath: "investments")
            game.setValue(motto, forKeyPath: "motto")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not initialize the game. \(error), \(error.userInfo)")
            }
        }
        update()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

