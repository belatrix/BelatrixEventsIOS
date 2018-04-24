//
//  ProjectManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProjectManager: NSObject {
    static let shared = ProjectManager()
    let serviceManager = ServiceManager.shared
    
    func getProjects(eventID: Int, completion: ((_ response: [Project]) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.interactionWith(eventID: eventID), method: .get, parameters: nil) { (json) in
            if let completion = completion {
                var projects: [Project] = []
                if let json = json {
                    guard let _ = json.error else {
                        for (_, subJson): (String, JSON) in json {
                            projects.append(Project(data: subJson))
                        }
                        completion(projects)
                        return
                    }
                    completion(projects)
                }
                completion(projects)
            }
        }
    }
}
