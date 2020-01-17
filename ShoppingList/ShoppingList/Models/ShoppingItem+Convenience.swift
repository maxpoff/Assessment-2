//
//  ShoppingItem+Convenience.swift
//  ShoppingList
//
//  Created by Maxwell Poffenbarger on 1/17/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingItem {
    
    convenience init(itemName: String, isBought: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.itemName = itemName
        self.isBought = isBought
    }
}//End of extension
