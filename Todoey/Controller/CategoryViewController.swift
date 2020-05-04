//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mac on 4/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    
    var categoryList : Results<Category>? // Result type is an auto updating container, it's more like an array and dictionary which means it can hold elements.
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
    }

 
      
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {// Everything starts from here after the viewdidload() method will have shown an empty tableview.
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            
            let category = Category()
            category.name = textField.text!
            category.uiColor = UIColor.randomFlat().hexValue() // colours are being added to the colour property at this point but it is not being used yet, as it is not set to any specific objects like cell in the tableview as  a whole, this can be sorted by setting colour to the cell inside the datasource method.
           // print(category.uiColor)
            self.save(category: category)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
                    }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //this works with the cell of focus which is a single one at a time depending on the count number in the above method.
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // methode is called from super class which returns cell.
        
        if let category = categoryList?[indexPath.row] {
        cell.textLabel?.text = category.name
        
            guard let catergoryColour = UIColor(hexString: category.uiColor)  else {fatalError("Navigation controller does not exist")}
            
        
        cell.backgroundColor =  catergoryColour
        cell.textLabel?.textColor = ContrastColorOf(catergoryColour, returnFlat: true)
            
        }
        return cell
    }
  

    
    


//MARK: - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryList?[indexPath.row] // this will bring out a selected category element and give a value to our selectedCategory property, this will give the selectedCategory property acess to both our name and uicolour variable inside the category class.
        }
    }

//MARK: - Data Manipulation Methods


    func save(category: Category) {
    
    do {
        try realm.write{
            realm.add(category)
        }
    } catch  {
        print("Error saving to database, \(error)")
    }
    
    tableView.reloadData()
    
}


    func loadCategory() {
        
        categoryList = realm.objects(Category.self) // This returns all the elements stored in the realm                                               db and loads it into the array.it auto uploads                                                 the category. it looks like the "categoryArray" acts like an object, it is able to hold all values for a class as seen here.
        
        tableView.reloadData()

    }

//MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if  let currentSelectedCategory = categoryList?[indexPath.row] {
        
        do {
            try realm.write{
                realm.delete(currentSelectedCategory)
            }
        } catch  {
            print("Error deleting Category,\(error)")
        }
        }
        
    }


}



 

