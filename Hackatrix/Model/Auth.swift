//
//  Auth.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/10/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import SwiftyJSON

class Auth: NSObject {
  
    var token: String?

    init(data: JSON) {
        self.token = data["token"].string
    }
}
