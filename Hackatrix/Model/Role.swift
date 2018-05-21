//
//  Role.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Role: NSObject {
  
  var id: Int
  var name: String
  
  init(_id : Int , _name: String){
    self.id = _id
    self.name = _name
  }
  
  init(data: JSON) {
    self.id = data["id"].intValue
    self.name = data["name"].stringValue
  }
}
