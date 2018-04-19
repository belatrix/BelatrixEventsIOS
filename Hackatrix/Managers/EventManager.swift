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
    
    func getEvent(type: EventType, completion: ((_ upcomingEvents: [Event], _ pastEvents: [Event]) -> Void)? = nil) {
        var eventURL = api.url.event.upcoming
        if type == .past {
            eventURL = api.url.event.past
        }
        
        self.serviceManager.useService(url: eventURL, method: .get, parameters: nil) { (json) in
            if let json = json {
                var upcomingEvents: [Event] = []
                var pastEvents: [Event] = []
                
                for (_, subJson): (String, JSON) in json {
                    if type == .upcoming {
                        upcomingEvents.append(Event(data: subJson))
                    } else {
                        pastEvents.append(Event(data: subJson))
                    }
                }
                
                if let completion = completion {
                    completion(upcomingEvents, pastEvents)
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
}
