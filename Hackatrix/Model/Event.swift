//
//  Event.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event: NSObject {
    var id: Int?
    var title: String?
    var image: String?
    var datetime: String?
    var address: String?
    var details: String?
    var registerLink: String?
    var sharingText: String?
    var hasInteractions: Bool?
    var interactionText: String?
    var interactionConfirmationText: String?
    var isFeatured: Bool?
    var isUpcoming: Bool?
    var isInteractionActive: Bool?
    var isActive: Bool?
    var location: Location?
    var city: [City]?
    
    init(data:JSON) {
        self.id = data["id"].int
        self.title = data["title"].string
        self.image = data["image"].string
        self.datetime = data["datetime"].string
        self.address = data["address"].string
        self.details = data["details"].string
        self.registerLink = data["register_link"].string
        self.sharingText = data["sharing_text"].string
        self.hasInteractions = data["has_interactions"].bool
        self.interactionText = data["interaction_text"].string
        self.interactionConfirmationText = data["interaction_confirmation_text"].string
        self.isFeatured = data["is_featured"].bool
        self.isUpcoming = data["is_upcoming"].bool
        self.isInteractionActive = data["is_interaction_active"].bool
        self.isActive = data["is_active"].bool
        self.location = Location(data: data["location"])
    }
}
