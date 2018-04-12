//
//  LocationVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 19/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LocationVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableViewLocation: UITableView!
    var cities: [City] = []
    var itemSelected: IndexPath!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LocationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Localización"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.location) as? LocationCell {
            cell.locationName.text = self.cities[indexPath.row].name
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
                self.itemSelected = indexPath
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension LocationVC: UITableViewDelegate {
}

