//
//  Auth.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/10/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Auth: NSObject {
    
    var id: Int?
    var email: String?
    var token: String?
    var isStaff: Bool?
    var isJury: Bool?
    var isActive: Bool?
    var isPasswordResetRequired: Bool?

    init(data: JSON) {
        self.token = data["token"].string
        self.id = data["user_id"].int
        self.email = data["email"].string
        self.isStaff = data["is_staff"].bool
        self.isJury = data["is_jury"].bool
        self.isPasswordResetRequired = data["is_password_reset_required"].bool
    }
}
