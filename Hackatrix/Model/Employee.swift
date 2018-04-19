//
//  Employee.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class Employee: NSObject {
    var id: Int?
    var name: String?
    var avatar: String?
    var email: String?
    var role: String?
    var twitter: String?
    var github: String?
    var website: String?
    var employeeQRCode: String?

    init(data: JSON) {
        self.id = data["id"].int
        self.name = data["name"].string
        self.avatar = data["avatar"].string
        self.email = data["email"].string
        self.role = data["role"].string
        self.twitter = data["twitter"].string
        self.github = data["github"].string
        self.website = data["website"].string
        self.employeeQRCode = data["employee_qr_code"].string
    }
}
