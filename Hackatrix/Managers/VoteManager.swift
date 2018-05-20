//
//  VoteManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class VoteManager: NSObject {
    static let shared = VoteManager()
    let serviceManager = ServiceManager.shared
    
  func castVote(eventId: Int, projectID: Int, completion: (() -> Void)? = nil , error:((String) -> ())? = nil) {
      self.serviceManager.useService(url: api.url.event.voteWith(eventID: eventId), method: .post, parameters:
        ["event_id" : eventId , "idea_id": projectID], completion: nil , result : { (json, errorMessage) in
            if let json = json {
              completion!()
            } else {
              error?(errorMessage!)
          }
        })
    }
}
