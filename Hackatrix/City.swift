//
//  City.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class City: NSObject {
    
    var id:Int?
    var name:String?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.name = data["name"].string
    }

}
