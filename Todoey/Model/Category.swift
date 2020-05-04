//
//  Category.swift
//  Todoey
//
//  Created by mac on 4/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
      @objc dynamic var uiColor: String = ""
    let items = List<Item>() // this is the forward relationship btw the category and item class, a one to many relationship, next is to define the inverse relationship.
}
