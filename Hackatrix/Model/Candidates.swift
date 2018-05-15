//
//  Candidates.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//
import SwiftyJSON

class Candidates: NSObject {
    
    var isCandidate: Bool?
    var teamMembers = [User]()
    
    init(data: JSON) {
        self.isCandidate = data["is_candidate"].bool
        for item in data["candidates"].arrayValue {
            teamMembers.append(User(data: item["user"]))
        }
    }
}
