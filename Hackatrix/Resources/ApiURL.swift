//
//  ApiURL.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

struct api {
    struct url {
        static let root = "http://bxevents.herokuapp.com:80"
        struct device {
            static let register = "\(root)/device/register/ios/"
            static func update(deviceID id:Int) -> String {
                return "\(root)/device/\(id)/update/city/"
            }
        }
        static func employeeWith(_ id:Int) -> String {
            return "\(root)/employee/\(id)/"
        }
        struct event {
            static func ID(_ id:Int) -> String {
                return "\(root)/event/\(id)/"
            }
            static func interactionWith(eventID id:Int) -> String {
                return "\(root)/event/\(id)/interaction/list/"
            }
            static let city = "\(root)/event/city/list/"
            static let featured = "\(root)/event/featured/"
            static func voteWith(interactionID id:Int) -> String {
                return "\(root)/event/interaction/\(id)/vote"
            }
            static let list = "\(root)/event/list/"
            static let upcoming = "\(root)/event/upcoming/list/"
            static let past = "\(root)/event/past/list/"
            static func ideaList(eventID id:Int) -> String {
                return "\(root)/event/\(id)/idea/list/"
            }
        }
        struct notifications {
            static let all = "\(root)/notifications/all/"
        }
        struct user {
            static func ID(_ id:Int) -> String {
                return "\(root)/user/\(id)/"
            }
            static func updatePasswordWithID(_ id:Int) -> String {
                return "\(root)/user/\(id)/update/password"
            }
            static let authenticate = "\(root)/user/authenticate/"
            static let create = "\(root)/user/create/"
            static let recover = "\(root)/user/recover/"
            static func recoverPasswordWithID(_ id:Int) -> String {
                return "\(root)/user/recover/\(id)/"
            }
        }
        struct idea {
            static let create = "\(root)/idea/create/"
        }
    }
}
