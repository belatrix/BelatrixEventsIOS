//
//  Location.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation
import SwiftyJSON

class Location: NSObject {

    var id:Int?
    var name:String?
    var latitude:String?
    var longitude:String?

    init(data:JSON) {
        self.id = data["id"].int
        self.name = data["name"].string
        self.latitude = data["latitude"].string
        self.longitude = data["longitude"].string
    }
    
}
