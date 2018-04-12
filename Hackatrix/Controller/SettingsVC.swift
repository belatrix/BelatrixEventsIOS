//
//  SettingsVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableViewSettings: UITableView!
    var cities: [City] = []
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customStyleTableView()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.citySetting {
            let locations = segue.destination as! LocationVC
            locations.cities = self.cities
        }
    }
    
    //MARK: - Functions
    
    func customStyleTableView() {
        self.tableViewSettings.tableFooterView = UIView()
    }
    
    func getCities(completitionHandler: @escaping () -> Void) {
        Alamofire.request(api.url.event.city).responseJSON { response in
            if let responseServer = response.result.value {
                let json = JSON(responseServer)
                for (_,subJson):(String, JSON) in json {
                    self.cities.append(City(data: subJson))
                }
                completitionHandler()
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Localización"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.setting) as? SettingsCell {
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cities = []
        self.getCities {
            self.performSegue(withIdentifier: K.segue.citySetting, sender: nil)
        }
    }
}


