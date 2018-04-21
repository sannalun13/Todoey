//
//  Item.swift
//  Todoey
//
//  Created by Sanna Lun on 19/4/2018.
//  Copyright © 2018 Sanna Lun. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    //defining the inverse relation of Item towards Category, many to one
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
