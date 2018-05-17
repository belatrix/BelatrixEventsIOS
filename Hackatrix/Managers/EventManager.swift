//
//  EventManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventManager: NSObject {
    static let shared = EventManager()
    let serviceManager = ServiceManager.shared

    func getEvent(eventID: Int, completion: ((_ event: Event) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.ID(eventID), method: .get, parameters: nil) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(Event(data: json))
                }
            }
        }
    }

    func getEventInteractions(eventID: Int, completion: ((_ interactions: [Project]) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.interactionWith(eventID: eventID), method: .get, parameters: nil) { (json) in
            if let json = json {
                var interactions: [Project] = []
                for (_, subJson): (String, JSON) in json {
                    interactions.append(Project(data: subJson))
                }
                if let completion = completion {
                    completion(interactions)
                }
            }
        }
    }

    func getFeaturedEvent(completion: ((_ event: Event) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.featured, method: .get, parameters: nil) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(Event(data: json))
                }
            }
        }
    }

    func getEvents(completion: ((_ events: [Event]) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.list, method: .get, parameters: nil) { (json) in
            if let json = json {
                var events: [Event] = []
                for (_, subJson): (String, JSON) in json {
                    events.append(Event(data: subJson))
                }
                if let completion = completion {
                    completion(events)
                }
            }
        }
    }
    
    func getEvent(type: EventType, completion: ((_ events: [Event]) -> Void)? = nil) {
        var eventURL = api.url.event.upcoming
        if type == .past {
            eventURL = api.url.event.past
        }
        
        self.serviceManager.useService(url: eventURL, method: .get, parameters: nil) { (json) in
            if let json = json {
                var events: [Event] = []
                
                for (_, subJson): (String, JSON) in json {
                    events.append(Event(data: subJson))
                }
                
                if let completion = completion {
                    completion(events)
                }
            }
        }
    }
    
    func getEventCities(completion: ((_ cities: [City]) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.event.city, method: .get, parameters: nil) { (json) in
            var cities: [City] = []
            if let json = json {
                for (_, subJson): (String, JSON) in json {
                    cities.append(City(data: subJson))
                }
            }
            if let completion = completion {
                completion(cities)
            }
        }
    }
  
  func getMeetingList(error:((String) -> ())? = nil, completion: ((_ meetings: [Meeting]) -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.event.meetingList, method: .get, parameters:nil, completion: nil, result: { (json, errorMessage) in
      if let json = json {
        if let completion = completion {
          let arrayValues = json.arrayValue
          var values : [Meeting] = [Meeting]()
          for item in arrayValues {
            values.append(Meeting(data: item))
          }
          completion(values)
        }
      } else {
        error?(errorMessage!)
      }
    })
  }
  
  func registerAttendance(token: String?, email: String, meetingId: Int, error:((String) -> ())? = nil, completion: ((_ user: User) -> Void)? = nil) {
    self.serviceManager.useService(url: api.url.event.meetingAttendance, method: .post, parameters: ["user_email": email, "meeting_id": meetingId], token: token, completion: nil, result: { (json, errorMessage) in
      if let json = json {
        if let completion = completion {
          let jsonUser = json.dictionaryValue["user"]!
          completion(User(data: jsonUser))
        }
      } else {
        error?(errorMessage!)
      }
    })
  }
}
