//
//  User.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var id: Int?
    var email: String?
    var fullName: String?
    var phoneNumber: String?
    var isStaff: Bool?
    var isJury: Bool?
    var isActive: Bool?
    var isModerator: Bool?
    var isPasswordResetRequired: Bool?
    var role: Role?
  
    /*
     {
     "id": 13,
     "email": "diegoveloper@gmail.com",
     "full_name": null,
     "phone_number": null,
         "role"  :     {
         "id": 3;
         "name" : "Mobile Developer";
       };
     "is_moderator": false,
     "is_staff": false,
     "is_active": true,
     "is_jury": false,
     "is_password_reset_required": true
     }
    */

    init(data: JSON) {
        self.id = data["id"].int
        self.email = data["email"].string
        self.fullName = data["full_name"].string
        self.phoneNumber = data["phone_number"].string
        if let currentRole = data["role"].dictionary {
          if let currentRoleName = currentRole["name"]{
            self.role = Role(_id: currentRole["id"]!.int!, _name: currentRoleName.string!)
          }
        }
        self.isStaff = data["is_staff"].bool
        self.isJury = data["is_jury"].bool
        self.isModerator = data["is_moderator"].bool
        self.isActive = data["is_active"].bool
        self.isPasswordResetRequired = data["is_password_reset_required"].bool
    }
}
