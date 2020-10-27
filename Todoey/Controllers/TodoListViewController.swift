//
//  ViewController.swift
//  Todoey
//
//  Created by preety on 25/10/20.
//  Copyright © 2020 Preety. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //an array of Item object
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for persisting data
        
        
        print(dataFilePath)
        
        
        //Linking Data Model (item.swift)
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
    
        
        //retreiving data for persisting
        loadItems()
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //value              condition     valueiftrue : valueiffalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        //for reuseable cell related tickmark prob
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    //if user select any row --- didSelectRowAt get called
       //Tick Markselection on  the row that user wants
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        //indexPath currently selected, then add accessory
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //changes the selection animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //How to create text field alert
        
        var textField = UITextField() //for global scope
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField // as alertTextField is local scope
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item Button inside the alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //print(textField.text) need global variable here for completion timing problem
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems(){
        //encode arrayItem data to plist
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch {
            print("Error encoding item array,\(error)" )
        }
    
        self.tableView.reloadData() //reload array after appending to show new item on the view
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in decoing array,\(error)")
            }
        }
        
    }
    

}

