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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        
        saveItems()
        
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
            
            self.saveItems()
        
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new todoey item."
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model manipulation methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error encodig data, \(error)")
//        }

        if let data = try? encoder.encode(itemArray) {
            do {
                try data.write(to: dataFilePath!)
            } catch {
            print ("Error encoding item array, \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([ToDoItems].self, from: data)
//            } catch {
//                print("Error decoding data, \(error)")
//            }
//        }
        
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([ToDoItems].self, from: Data(contentsOf: dataFilePath!))
        } catch {
            print ("Error decoding item array, \(error)")
        }
    }
}

