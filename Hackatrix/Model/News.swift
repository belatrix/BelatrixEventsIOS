//
//  News.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 12/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class News: NSObject {
    var id: Int?
    var text: String?
    var datetime: String?
    var city: Int?
    var isActive: Bool?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.text = data["text"].string
        self.datetime = data["datetime"].string
        self.city = data["city"].int
        self.isActive = data["is_active"].bool
    }
    
    init(datetime: String, text: String) {
        self.datetime = datetime
        self.text = text
    }
}
