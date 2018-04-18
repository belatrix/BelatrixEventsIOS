//
//  DetailVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 10/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import SwiftyJSON
import SafariServices

class DetailVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var detailTitle: UILabel!
    var detailEvent: Event!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfo()
        self.addTitleinMainBanner()
        self.bussinesValidations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Detalle"
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.map {
            if let mapVC = segue.destination as? MapVC {
                mapVC.latitud = detailEvent.location?.latitude ?? "-12.099947"
                mapVC.longitud = detailEvent.location?.longitude ?? "-77.018978"
                mapVC.name = detailEvent.location?.name ?? "Belatrix"
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func showWebPage(_ sender: Any) {
        if let registerLink = detailEvent.registerLink, let helpURL = URL(string: registerLink) {
            let safariView = SFSafariViewController(url: helpURL)
            self.present(safariView, animated: true, completion: nil)
        }
    }
    
    //MARK: - Functions
    
    func addInfo() {
        self.getBanner()
        if let datetime = detailEvent.datetime {
            self.dateLbl.text = Utils.date.getFormatterEvent(dateString: datetime)
        }
        if detailEvent.address == "" {
            self.locationBtn.setTitle("Belatrix", for: .normal)
        } else {
            self.locationBtn.setTitle(detailEvent.address, for: .normal)
        }
        if detailEvent.details == "" {
            self.descriptionLbl.text = "No hay description"
        } else {
            self.descriptionLbl.text = detailEvent.details
        }
        self.urlBtn.setTitle(detailEvent.registerLink ?? "", for: .normal)
    }

    func getBanner() {
        if let image = self.detailEvent.image, let url = URL(string: image) {
            self.mainImage.af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    func addTitleinMainBanner() {
        self.detailTitle.text = detailEvent.title
    }
    
    func bussinesValidations() {
        if let isInteractionActive = self.detailEvent.isInteractionActive, let hasInteractions = self.detailEvent.hasInteractions {
            if !isInteractionActive {
                self.tabBarController?.tabBar.isHidden = true
            }
            if !hasInteractions {
                self.tabBarController?.tabBar.items?[1].isEnabled = false
            }
        }
    }
    
}
