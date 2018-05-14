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
    
    func getIdeas(eventID: Int, completion: ((_ response: [Idea]) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.ideaList(eventID: eventID), method: .get, parameters: nil) { (json) in
            if let completion = completion {
                var ideaList: [Idea] = []
                if let json = json, json.array?.count ?? 0 > 0 {
                    guard let _ = json.error else {
                        for (_, subJson): (String, JSON) in json {
                            ideaList.append(Idea(data: subJson))
                        }
                        completion(ideaList)
                        return
                    }
                    completion(ideaList)
                }
                completion(ideaList)
            }
        }
    }
    
    func createIdea(eventID: Int, title: String, description: String, error: @escaping () -> (), success: @escaping (Idea) -> ()) {
        if let userId = UserManager.shared.currentUser?.id {
            let paramenters: [String: Any] = ["author": userId, "event": eventID, "title": title, "description": description]
            self.serviceManager.useAuthService(url: api.url.idea.create, method: .post, parameters: paramenters) { (json) in
                if let json = json {
                    success(Idea(data: json))
                } else {
                    error()
                }
            }
        } else {
            error()
        }
    }
}
