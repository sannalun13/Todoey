//
//  ViewController.swift
//  Todoey
//
//  Created by Sanna Lun on 31/3/2018.
//  Copyright © 2018 Sanna Lun. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var itemArray = [ToDoItems]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadItems()
        
    }
    
    //MARK: - Tableview data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary operator
        //value = condition ? valueForTrue : valueForFalse
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row].title!) 
        
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        itemArray[indexPath.row].setValue("\(itemArray[indexPath.row].title!) (Completed)", forKey: "title")
        
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
//
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user click the button
            
            let newItem = ToDoItems(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
        
        do {
            try context.save()
        } catch {
            print ("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()){
        
        //let request : NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print ("Error handling fetching data, \(error)")
        }
        
        tableView.reloadData()
    }
}
//MARK: - search bar methods

extension ToDoViewController: UISearchBarDelegate {
    
    func showSearchResult(text: String){
        
        let request : NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }  else {
            showSearchResult(text: searchBar.text!)
            
        }
    }
}

