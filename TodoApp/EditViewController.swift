//
//  EditViewController.swift
//  TodoApp
//
//  Created by Scott Magee on 9/28/16.
//  Copyright © 2016 Scott Magee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemTextField: UITextField!
    lazy var context = CoreDataStack().getContext();
    var passedValue: Item!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.itemTextField.text = passedValue.itemName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Add new item
        saveName(name: textField.text!)
    }
    
    func saveName(name: String) {
        passedValue.setValue(name, forKey: "itemName")
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func pressedSave(_ sender: AnyObject) {
        saveName(name: itemTextField.text!)
    }
}
