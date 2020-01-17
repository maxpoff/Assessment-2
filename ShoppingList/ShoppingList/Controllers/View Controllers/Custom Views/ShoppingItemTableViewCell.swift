//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Maxwell Poffenbarger on 1/17/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import UIKit

protocol ShoppingItemTableViewCellDelegate: class {
    func isCompleteBoxTapped(_ sender: ShoppingItemTableViewCell)
}

class ShoppingItemTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    weak var delegate: ShoppingItemTableViewCellDelegate?
    
    //MARK: Actions
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        delegate?.isCompleteBoxTapped(self)
    }
    
    fileprivate func updateButton(_ isBought: Bool) {
        let imageName = isBought ? "complete" : "incomplete"
        isCompleteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func update(shoppingItem: ShoppingItem) {
        itemNameLabel.text = shoppingItem.itemName
        updateButton(shoppingItem.isBought)
    }
    
}//End of class
