//
//  Project.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation
import SwiftyJSON

class Project: NSObject {
    var id: Int?
    var text: String?
    var votes: Int?
    var isActive: Bool?
    var event: Int?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.text = data["text"].string
        self.votes = data["votes"].int
        self.isActive = data["isActive"].bool
        self.event = data["event"].int
    }
}
