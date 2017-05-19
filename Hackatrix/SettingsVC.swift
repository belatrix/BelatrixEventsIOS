//
//  SettingsVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewSettings: UITableView!
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customStyleTableView()
    }
    
    //MARK: - Functions
    
    func customStyleTableView() {
        self.tableViewSettings.tableFooterView = UIView()
    }

}

//MARK: - UITableViewDataSource

extension SettingsVC:UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.setting) as! SettingsCell
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue.citySetting, sender: nil)
    }
}


