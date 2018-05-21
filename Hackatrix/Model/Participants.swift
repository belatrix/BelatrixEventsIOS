//
//  Participants.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/14/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Participants: NSObject {
    
    var isRegistered: Bool?
    var teamMembers = [User]()
    
    init(data: JSON) {
        self.isRegistered = data["is_registered"].bool
        for item in data["team_members"].arrayValue {
            teamMembers.append(User(data: item["user"]))
        }
    }
}
