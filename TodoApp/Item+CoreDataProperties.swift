//
//  Item+CoreDataProperties.swift
//  TodoApp
//
//  Created by Scott Magee on 9/28/16.
//  Copyright © 2016 Scott Magee. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var itemName: String?

}
