//
//  UserManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserManager: NSObject {
    static let shared = UserManager()
    let serviceManager = ServiceManager.shared
    var currentUser : User?  {
      if let currentJSON = loadJSON() {
        return User(data: currentJSON)
      }
      return nil
    }

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

    func authenticate(username: String, password: String,error: @escaping () -> Void, completion: ((_ user: Auth) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.user.authenticate, method: .post, parameters: ["username": username, "password": password]) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(Auth(data: json))
                } else {
                  error()
              }
            } else {
                error()
            }
        }
    }
  
  func profile(token: String, error: @escaping () -> Void, completion: (() -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.user.profile, method: .get, parameters: nil, token: token) { (json) in
      if let json = json {
        if let completion = completion {
          let jsonUser = json.dictionaryValue["user"]
          self.saveJSON(j: jsonUser!)
          completion()
        }
      } else {
        error()
      }
    }
  }

  func createNewUser(email: String, error:((String) -> ())? = nil, completion: ((_ user: User) -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.user.create, method: .post, parameters: ["email": email], completion: nil, result: { (json, errorMessage) in
            if let json = json {
                if let completion = completion {
                    completion(User(data: json))
                }
            } else {
              error?(errorMessage!)
            }
    })
    }
  
  func logout(token: String, error: @escaping () -> Void, completion: (() -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.user.logout, method: .post, parameters: nil, token: token) { (json) in
      if let json = json {
        if let completion = completion {
          self.removeJSON()
          completion()
        }
      } else {
        error()
      }
    }
  }

  func recoverUser(email: String, error:((String) -> ())? = nil ,completion: (() -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.user.recover, method: .post, parameters: ["email": email], completion: nil, result: { (json, errorMessage) in
      if let json = json {
        if let completion = completion {
          completion()
        }
      } else {
        error?(errorMessage!)
      }
    })
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
  
  func updateUser(token: String, fullName: String, phoneNumber: String, roleId : Int, error:((String) -> ())? = nil, completion: ((_ user: User) -> Void)? = nil) {
    
    var params = [String: Any]()
    if !fullName.trimmingCharacters(in: .whitespaces).isEmpty {
      params["full_name"] = fullName as AnyObject
    }
    if !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
      params["phone_number"] = phoneNumber as AnyObject
    }
    params["role_id"] = roleId as AnyObject
    
    
    self.serviceManager.useService(url: api.url.user.updateProfile, method: .patch,
                                   parameters: params, token: token,
                                   completion: nil, result: { (json, errorMessage) in
      if let json = json {
        if let completion = completion {
          self.saveJSON(j: json)
          completion(User(data: json))
        }
      } else {
        error?(errorMessage!)
      }
    })
  }
  
  func getRoles(token: String?, error:((String) -> ())? = nil, completion: ((_ roles: [Role]) -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.user.roles, method: .get, parameters:nil, token : token , completion: nil, result: { (json, errorMessage) in
      if let json = json {
        if let completion = completion {
          let arrayRoles = json.arrayValue
          var values : [Role] = [Role]()
          for item in arrayRoles {
            values.append(Role(data: item))
          }
          completion(values.sorted(by: {(role1, role2) -> Bool in
                  return role1.id < role2.id
            }))
        }
      } else {
        error?(errorMessage!)
      }
    })
  }
  
  public func saveJSON(j: JSON) {
    let defaults = UserDefaults.standard
    defaults.setValue(j.rawString()!, forKey: "jsonUSER")
    defaults.synchronize()
  }
  
  public func removeJSON() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "jsonUSER")
    defaults.synchronize()
  }
  
  public func loadJSON() -> JSON? {
    let defaults = UserDefaults.standard
    if let dataString = defaults.string(forKey: "jsonUSER") {
      return JSON.init(parseJSON: dataString)
    }
    return nil
  }
}
