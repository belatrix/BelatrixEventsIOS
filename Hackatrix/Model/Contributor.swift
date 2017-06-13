//
//  Contributor.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 17/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class Contributor: NSObject {
    
    var icon:String?
    var name:String?
    
    init(data:JSON) {
        self.icon = data["icon"].string
        self.name = data["name"].string
    }

}
