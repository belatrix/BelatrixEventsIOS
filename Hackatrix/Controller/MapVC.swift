//
//  MapVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 11/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    var latitud: String!
    var longitud: String!
    var name: String!
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMap()
    }
    
    //MARK: - Functions
    
    func createMap() {
        if let latitud = Double(self.latitud), let longitud = Double(self.longitud) {
            let lat = CLLocationDegrees(exactly: latitud)
            let long = CLLocationDegrees(exactly: longitud)
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = self.name
            self.mapView.addAnnotation(annotation)
        }
    }
}

