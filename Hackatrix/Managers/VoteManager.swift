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
    
    func castVote(projectID: Int, completion: (() -> Void)? = nil) {
        serviceManager.useService(url: api.url.event.voteWith(interactionID: projectID), method: .get, parameters: nil) { (json) in
            if let completion = completion {
                completion()
            }
        }
    }
}
