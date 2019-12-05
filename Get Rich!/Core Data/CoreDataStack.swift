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
    
    override init() {
        super.init()
        if Game.count == 0 {
            initGame()
        }
        update()
    }
    
    func initAfterReset(){
        initGame()
    }
    
    func initGame() {
        if let entity = NSEntityDescription.entity(forEntityName: "Game", in: context) {
            let game = NSManagedObject(entity: entity, insertInto: context)
            game.setValue(0, forKeyPath: "balance")
            game.setValue(1, forKeyPath: "billSize")
            game.setValue(1, forKeyPath: "multiplier")
            game.setValue(0, forKeyPath: "investments")
            game.setValue(NSLocalizedString("str_quote_init", comment: ""), forKeyPath: "motto")
            game.setValue(0, forKey: "income")
            
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
    
    func clearContext() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Error in clearing context, step 1. \(error), \(error.userInfo)")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error in clearing context. \(error), \(error.userInfo)")
        }
        update()
    }
    
    func deleteLast(){
        if let last = Game.last {
            context.delete(last)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not delete the item. \(error), \(error.userInfo)")
            }
        }
        update()
    }
    
}

