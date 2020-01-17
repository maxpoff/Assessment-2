//
//  CoreDataStack.swift
//  ShoppingList
//
//  Created by Maxwell Poffenbarger on 1/17/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext { return container.viewContext }
}//End of class

