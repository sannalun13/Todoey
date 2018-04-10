//
//  ViewController.swift
//  Todoey
//
//  Created by Sanna Lun on 31/3/2018.
//  Copyright © 2018 Sanna Lun. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [ToDoItems]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = ToDoItems()
        newItem.itemTitle = "Call Ville"
        itemArray.append(newItem)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        
    }
    
    //MARK: Tableview data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].itemTitle
        
        //Ternary operator
        //value = condition ? valueForTrue : valueForFalse
        
        cell.accessoryType = itemArray[indexPath.row].doneItem ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row].itemTitle)
        
        itemArray[indexPath.row].doneItem = !itemArray[indexPath.row].doneItem
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user click the button
            
            let newItem = ToDoItems()
            newItem.itemTitle = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new todoey item."
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

