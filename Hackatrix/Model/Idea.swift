//
//  Idea.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Idea: NSObject {
    
    let id: Int?
    let title: String?
    var ideaDescription: String?
    var isCompleted: Bool?
    var isValid: Bool?
    var author: User?
    var event: Event?
    
    init(data: JSON) {
        self.id = data["id"].int
        self.title = data["title"].string
        self.ideaDescription = data["description"].string
        self.isValid = data["is_valid"].bool
        self.isCompleted = data["is_completed"].bool
        self.author = User(data: data["author"])
        self.event = Event(data: data["event"])
    }
}
