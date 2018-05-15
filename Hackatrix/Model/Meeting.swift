//
//  Meeting.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Meeting: NSObject {
  
  var id: Int
  var name: String
  
  init(data: JSON) {
    self.id = data["id"].intValue
    self.name = data["name"].stringValue
  }
}

