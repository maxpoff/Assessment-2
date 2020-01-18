//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Maxwell Poffenbarger on 1/17/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingItemController.shared.fetchedResultsController.delegate = self
    }
    
    //MARK: Actions
    @IBAction func addItemButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    //MARK: Alert Controller
    
    func presentAlertController() {
        
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter item here..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addItem = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alertController.textFields?[0].text else {return}
            ShoppingItemController.shared.create(itemName: itemName)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addItem)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingItemController.shared.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingItemController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ShoppingItemTableViewCell else {return UITableViewCell()}
        
        let item = ShoppingItemController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.update(shoppingItem: item)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = ShoppingItemController.shared.fetchedResultsController.object(at: indexPath)
            ShoppingItemController.shared.delete(shoppingItem: itemToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ShoppingItemController.shared.fetchedResultsController.sections?[section].name == "0" {
            return "Incomplete"
        } else {
            return "Complete"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 12
    }
    
}//End of class

extension ShoppingListTableViewController: ShoppingItemTableViewCellDelegate {
    
    func isCompleteBoxTapped(_ sender: ShoppingItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let item = ShoppingItemController.shared.fetchedResultsController.object(at: indexPath)
        ShoppingItemController.shared.toggleIsBought(shoppingItem: item)
        sender.update(shoppingItem: item)
    }
    
}//End of extension

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .fade)
            
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .fade)
            
        default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}//End of extension

