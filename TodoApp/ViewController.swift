//
//  ViewController.swift
//  TodoApp
//
//  Created by Scott Magee on 9/28/16.
//  Copyright © 2016 Scott Magee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    lazy var context = CoreDataStack().getContext()
    var items:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let results =
                try context.fetch(fetchRequest)
            items = results as! [NSManagedObject]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(in: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        if let item: Item = items[indexPath.row] as? Item{
            cell.textLabel?.text = item.itemName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Add new item
        saveName(name: textField.text!)
        textField.text = ""
    }
    
    func saveName(name: String) {
        
        let entity =  NSEntityDescription.entity(forEntityName: "Item",
                                                 in:context)
        
        let item = NSManagedObject(entity: entity!,
                                     insertInto: context)
        
        item.setValue(name, forKey: "itemName")
        
        do {
            try context.save()
            items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func deleteItem(at: IndexPath) {
        let toDelete = items.remove(at: at.row)
        context.delete(toDelete)
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get Cell Item
        let indexPath = tableView.indexPathForSelectedRow;
        print("You selected cell #\(indexPath?.row)!")
        let currentItem = items[(indexPath?.row)!];
        
        let viewController = segue.destination as! EditViewController
        
        viewController.passedValue = currentItem as! Item
    }
    
}

