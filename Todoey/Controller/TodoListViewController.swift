//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems :  Results<Item>? // Results cannot be directly instantiated.
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{// everything within this block of code is going to happen as soon as selectedCategory gets a value that will be set inside the destinationVC.selectedCategory = categoryArray[indexPath.row] found in the "prepare for seguel" method in the ToDoListController Class.
            
            loadItems()
            
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        tableView.separatorStyle = .none
        
   }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex =  selectedCategory?.uiColor {
          
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            if  let navBarColour = UIColor(hexString: colourHex){
                
                navBar.backgroundColor = navBarColour
                    //sets colour to all nav items including the button at a go
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.backgroundColor = navBarColour // not too pleased with this
                
                          
            }
            
          
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Configure the cell’s contents.
        if let item = todoItems?[indexPath.row].title {
            
            cell.textLabel?.text = item
            
            if let colour = UIColor(hexString: selectedCategory!.uiColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
               cell.backgroundColor = colour
               cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true) //use this to set ensure the font of text remain visible as gradient gets darker.
            }
           
           
                
            
            if todoItems?[indexPath.row].done == true {
                cell.accessoryType = .checkmark
            } else{
                cell.accessoryType = .none
            }
        } else{
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let currentItem = todoItems?[indexPath.row] { // if there is an element at this current indexpath, run the code below and set it to the variable currentItem.
            
            do {
                try realm.write{// updating data using Realm. All codes inside here is updated
                  
                    currentItem.done = !currentItem.done // the symbol ! in front of the currentItem variable means opposite, this means i am setting the value of the "currentItem.done" to its opposite, which is like false = true and true=false
                    
                     //realm.delete(currentItem) -> this is used to delete from Realm. Realm seems to have the funtionality of both an array and db in one.
                }
                
            } catch  {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData() // call this method which will call the tableview datasource method above which already contains the code to either update the checkmark or not.
        
        //     if todoItems[indexPath.row].done == false{ // This delegate takes care of interaction with the cells, if you interact with it here like this, you can set what gets populated to this particular cell using the datasource delegate method above.
        //
        //            todoItems[indexPath.row].done = true
        //        }
        //        else{
        //            todoItems[indexPath.row].done = false
        //        }
        //
        
        //   self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            
            
            if let currentCategory = self.selectedCategory{// remerber that the selectedCategory property is optional, check if it contains value.
                
                do{
                    try self.realm.write{
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() // set the date variable to the current date the item was created.
                        currentCategory.items.append(newItem) // Remember that each category will have it's own items, we need to think of a point in the code where each category will be assigned it's items and this is the best place as this is the only place we will be adding our items, so right here, we can immediately append all the newly created items to the selected category using the selectedCategory property.
                    }
                } catch{ print("Error saving new item, \(error)")
                    
                }
             
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //    func saveItems() { // ANGELA DELETED THIS
    //
    //                   do{
    //                    try context.save() // save to the persistent store(db) which is mostly SQlite
    //                   } catch{
    //                       print("Error saving context \(error)")
    //                   }
    //        self.tableView.reloadData() // always use this to reload data after adding new items.this forces the datasource method to reload the data it had before and apply new changes to the interface.
    //    }
    
    
    func loadItems() {// This is a querry to the realm db to sort out items relating to the querry search and load up the list with the results.
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
        
        override func updateModel(at indexPath: IndexPath) {
            
            if  let currentSelectedCategory = todoItems?[indexPath.row] {
            
            do {
                try realm.write{
                    realm.delete(currentSelectedCategory)
                }
            } catch  {
                print("Error deleting Item,\(error)")
            }
            }
            
        }


    
}

//MARK: - Search Bar Delegate method

extension TodoListViewController : UISearchBarDelegate {
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()

     }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else{
            searchBarSearchButtonClicked(searchBar) // helps the search to generate results in real-time
            }
        }
}
