//
//  UserManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    let serviceManager = ServiceManager.shared

    func getUser(userID: Int, completion: ((_ user: User) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.user.ID(userID), method: .get, parameters: nil) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(User(data: json))
                }
            }
        }
    }

    func updateUserPassword(userID: Int, currentPassword: String, newPassword: String, completion: ((_ user: User) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.user.updatePasswordWithID(userID), method: .patch, parameters: ["current_password": currentPassword, "new_password": newPassword]) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(User(data: json))
                }
            }
        }
    }

    func updateUserPassword(username: String, password: String, completion: ((_ user: User) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.user.authenticate, method: .post, parameters: ["username": username, "password": password]) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(User(data: json))
                }
            }
        }
    }

    func createNewUser(email: String, completion: ((_ user: User) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.user.create, method: .post, parameters: ["email": email]) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(User(data: json))
                }
            }
        }
    }

    func recoverUser(email: String, completion: (() -> Void)? = nil) {
        //TODO: Check response and handle it
        self.serviceManager.useService(url: api.url.user.recover, method: .post, parameters: ["email": email]) { (json) in
            if let json = json {
                if let completion = completion {
                    completion()
                }
            }
        }
    }

    func recoverPassword(userID: Int, completion: (() -> Void)? = nil) {
        //TODO: Check response and handle it
        self.serviceManager.useService(url: api.url.user.recoverPasswordWithID(userID), method: .get, parameters: nil) { (json) in
            if let json = json {
                if let completion = completion {
                    completion()
                }
            }
        }
    }
}
