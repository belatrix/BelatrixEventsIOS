//
//  Rate.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/20/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class Rate: NSObject {
  var categoryId: Int?
  var categoryName: String?
  var value: Int?
 
  init(data: JSON) {
    let category = data["category"].dictionaryValue
    self.categoryId = category["id"]!.int
    self.categoryName = category["name"]!.string
    self.value = data["value"].int
  }
}
