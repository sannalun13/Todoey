 //
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sanna Lun on 18/4/2018.
//  Copyright © 2018 Sanna Lun. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //the first time when you are creating Realm instanse
    //therefore it can throw, but this is completely fine
    //Initialise a few access point to our realm database
    let realm = try! Realm()
    
    //changed from an array of items to this new collection type
    //a collection of results that are Category objects
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    //MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of categories as the number of rows
        //return one if it's nil
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //Before we bring the user to the new page
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //categories is now assigned to an auto-update result
            //which will monitor for changes automatically
            //we don't need to assign things to it anymore
            
            //self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data manipulation methods
    //we pass in the new category that we created
    func save(category: Category) {
        //do some changes in our realm database
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving category, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        //set categories to look inside our realm, and fetch objects that belongs to the category data type
        categories = realm.objects(Category.self)
        
        //call all of the tableview datasource methods again, to refresh the page
        tableView.reloadData()

    }


    
    
}
