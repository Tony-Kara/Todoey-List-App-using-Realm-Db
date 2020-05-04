//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by mac on 5/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.rowHeight = 80
        
    }
    //MARK: - TableView Data Source Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                cell.delegate = self //from SwipeTableCell Pod
                return cell
    }
        

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
           print("Delete cell")
          
            self.updateModel(at: indexPath) // inside here, i need to perform the delete action by deleting the selected category from my Realm which also means from my tableview, but i cannot do this from the "SwipeTableViewVC" as this is not the UI for categoryVC,the idea is to insert the actual code to do this inside the "CategoryVC" BY overiding this method created inside this class.

            
           // tableView.reloadData()// this needs to be removed as a result of the "expansionStyle property selected below"
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions { //this method is called when the user swipes on any cell inside the tableview.
        var options = SwipeOptions()
        options.expansionStyle = .destructive // this option will remove the last row from the tableview which at this point has not been removed from the realm db, so the reloadData method needs to be removed to avoid a crash
        return options
        
       
        
        
    }

    func updateModel(at indexPath: IndexPath) {
        //update our data model
    }
    
    
    
    
}
