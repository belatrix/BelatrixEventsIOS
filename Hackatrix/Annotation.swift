//
//  Annotation.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//


import MapKit

class Annotation: NSObject, MKAnnotation {
    let titleAnnotation: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.titleAnnotation = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitleAnnotation: String {
        return locationName
    }
}
