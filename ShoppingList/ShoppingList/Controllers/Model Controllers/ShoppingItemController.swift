//
//  ShoppingItemController.swift
//  ShoppingList
//
//  Created by Maxwell Poffenbarger on 1/17/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation
import CoreData

class ShoppingItemController {
    
    static let shared = ShoppingItemController()
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    //MARK: CRUD Functions
    func create(itemName: String) {
        _ = ShoppingItem(itemName: itemName)
        saveToPersistentStore()
    }
    
    func toggleIsBought(shoppingItem: ShoppingItem) {
        shoppingItem.isBought = !shoppingItem.isBought
        saveToPersistentStore()
    }
    
    func delete(shoppingItem: ShoppingItem) {
        CoreDataStack.context.delete(shoppingItem)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("There was a problem saving: \(error)")
        }
    }
    
    let fetchedResultsController: NSFetchedResultsController<ShoppingItem> = {
        
        let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let isBoughtSort = NSSortDescriptor(key: "isBought", ascending: true)
        let idkSort = NSSortDescriptor(key: "itemName", ascending: true)
        fetchRequest.sortDescriptors = [isBoughtSort, idkSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isBought", cacheName: nil)
    }()
    
}//End of class
