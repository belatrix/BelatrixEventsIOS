//
//  AboutVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var collectionViewContributors: UICollectionView!
    let contributors:[[String:String]] = [["icon":"erikIcon","name":"Erik Flores"],["icon":"diegoIcon","name":"Diego Velásquez "],["icon":"carinaIcon","name":"Carina Valdez"],["icon":"sergioIcon","name":"Sergio Infante"],["icon":"karlaIcon","name":"Karla Cerrón"],["icon":"fernandoIcon","name":"Fernando Puebla"]]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - Actions
    
    @IBAction func sendMail(_ sender: Any) {
        let toEmail = K.email.contact
        let subject = "Hacktrix App".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let body = "Hola!".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "mailto:\(toEmail)?subject=\(subject ?? "")&body=\(body ?? "")"
        
        if let url = URL(string:urlString) {
            UIApplication.shared.openURL(url)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension AboutVC:UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contributors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cell.contributor, for: indexPath) as! ContributorCell
        let item = self.contributors[indexPath.row]
        cell.image.layer.cornerRadius = 30
        cell.image.image = UIImage(named: item["icon"]!)
        cell.name.text =  item["name"]
        return cell
    }
    
}


