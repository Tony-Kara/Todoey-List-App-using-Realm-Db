//
//  Item.swift
//  Todoey
//
//  Created by mac on 4/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var dateCreated: Date?
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false                                    //from the Category class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
