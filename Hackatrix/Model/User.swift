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
    var firstName: String?
    var lastName: String?
    var isStaff: Bool?
    var isActive: Bool?
    var isPasswordResetRequired: Bool?

    init(data: JSON) {
        self.id = data["pk"].int
        self.email = data["email"].string
        self.firstName = data["first_name"].string
        self.lastName = data["last_name"].string
        self.isStaff = data["is_staff"].bool
        self.isActive = data["is_active"].bool
        self.isPasswordResetRequired = data["is_password_reset_required"].bool
    }
}
