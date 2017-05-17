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
    let contributors:[[String:String]] = [["icon":"ErikIcon","name":"Erik Flores"],["icon":"DiegoIcon","name":"Diego Velásquez "],["icon":"KarlaIcon","name":"Karla Cerrón"],["icon":"SergioIcon","name":"Sergio Infante"],["icon":"CarinaIcon","name":"Carina Valdez"],["icon":"FernandoIcon","name":"Fernando Puebla"],["icon":"CarlosIcon","name":"Carlos Monzón"],["icon":"GladysIcon","name":"Gladys Cuzcano"],["icon":"RaulIcon","name":"Raul Rashuaman"]]
    
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


