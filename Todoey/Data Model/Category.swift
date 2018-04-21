//
//  Category.swift
//  Todoey
//
//  Created by Sanna Lun on 19/4/2018.
//  Copyright © 2018 Sanna Lun. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    //dynamic var: we can monitor changes during runtime
    @objc dynamic var name : String = ""
    //forward relationship, one to many
    let items = List<Item>()
}

