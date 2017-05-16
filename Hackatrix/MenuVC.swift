//
//  MenuVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 8/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import SafariServices

class MenuVC: UIViewController {
    
     //MARK: - Properties
    
    @IBOutlet weak var tableViewMenu: UITableView!
    let items:[[String:String]] = [["icon":"NewsIcon","name":"Novedades"],["icon":"AboutIcon","name":"Acerca de"],["icon":"HelpIcon","name":"Ayuda"]]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customStyleTableView()
        self.navigationItem.backBarButtonItem?.title = "@"
    }
    
    //MARK: - Functions
    
    func customStyleTableView(){
        let footerView = UIView()
        self.tableViewMenu.tableFooterView = footerView
    }
}

//MARK: - UITableViewDataSource

extension MenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.menu) as! ItemMenuCell
        let item = items[indexPath.row]
        cell.imageItemMenu.image = UIImage(named: item["icon"]!)
        cell.nameItemMenu.text = item["name"]!
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension MenuVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: K.segue.news, sender: nil)
        case 1:
            self.performSegue(withIdentifier: K.segue.about, sender: nil)
        case 2:
            let helpURL = URL(string: K.url.belatrix)
            let safariView = SFSafariViewController(url: helpURL!)
            self.present(safariView, animated: true, completion: nil)
        default:
            self.performSegue(withIdentifier: K.segue.settings, sender: nil)
        }
    }
    
}


