//
//  Idea.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

struct Idea: Codable {
    
    let id: Int?
    let title: String?
    var description: String?
    var isCompleted: Bool?
    var isValid: Bool?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.title = data["title"].string
        self.description = data["description"].string
        self.isValid = data["is_valid"].bool
        self.isCompleted = data["is_completed"].bool
    }
}
