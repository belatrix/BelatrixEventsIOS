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
    //extra stuff
    var participant: String? = ""
    var candidate: String? = ""
    var member: String? = ""
    var attendance: String? = ""
  
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
  
  /*
   attendance =     (
   {
   meeting =             {
   id = 2;
   name = "Full Day - Hackatrix 2018";
   };
   },
   {
   meeting =             {
   id = 1;
   name = "Kick Off - Hackatrix 2018";
   };
   }
   );
   author =     (
   );
   candidate =     (
   {
   idea =             {
   id = 50;
   title = teeter;
   };
   }
   );
   events =     (
   );
   participant =     (
   {
   idea =             {
   id = 60;
   title = daddy;
   };
   }
   );

   */
  
    func parseExtraData(fullData: JSON) {
      let arrayEvents = fullData["events"].arrayValue
      for item in arrayEvents {
        let object = item["event"].dictionaryValue
        participant?.append(object["title"]!.stringValue)
        participant?.append("\n")
      }
      participant?.removeLast()
      
      let arrayParticipants = fullData["participant"].arrayValue
      for item in arrayParticipants {
        let object = item["idea"].dictionaryValue
        member?.append(object["title"]!.stringValue)
        member?.append("\n")
      }
      member?.removeLast()
      
      let cantidateArray = fullData["candidate"].arrayValue
      for item in cantidateArray {
        let object = item["idea"].dictionaryValue
        candidate?.append(object["title"]!.stringValue)
        candidate?.append("\n")
      }
      candidate?.removeLast()
      
      let attendanceArray = fullData["attendance"].arrayValue
      for item in attendanceArray {
        let object = item["meeting"].dictionaryValue
        attendance?.append(object["name"]!.stringValue)
        attendance?.append("\n")
      }
      attendance?.removeLast()
    }
  
}
