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
            static let meetingList = "\(root)/event/meeting/list/"
            static let meetingAttendance = "\(root)/event/register/attendance/"
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
            static let profile = "\(root)/user/profile/"
            static let create = "\(root)/user/create/"
            static let recover = "\(root)/user/recover/"
            static func recoverPasswordWithID(_ id:Int) -> String {
                return "\(root)/user/recover/\(id)/"
            }
            static let logout = "\(root)/user/logout/"
            static let updateProfile = "\(root)/user/update/"
            static let roles = "\(root)/user/role/list/"
            static let ideas = "\(root)/user/ideas/"
        }
        struct idea {
            static let create = "\(root)/idea/create/"
            static func participants(_ id:Int) -> String {
                return "\(root)/idea/\(id)/participants/"
            }
            static func registerParticipant(_ id: Int) -> String {
                return "\(root)/idea/\(id)/register/"
            }
            static func unregisterParticipant(_ id: Int) -> String {
                return "\(root)/idea/\(id)/unregister/"
            }
            static func candidates(_ id:Int) -> String {
                return "\(root)/idea/\(id)/candidates/"
            }
            static func registerCandidate(_ id:Int) -> String {
                return "\(root)/idea/\(id)/register/candidate/"
            }
            static func unregisterCandidate(_ id: Int) -> String {
                return "\(root)/idea/\(id)/unregister/candidate/"
            }
            static func approveCandidateWithIdeaId(_ id: Int) -> String {
                return "\(root)/idea/\(id)/candidate/approval/switch/"
            }
        }
    }
}
