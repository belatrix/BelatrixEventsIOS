//
//  MoreVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/13/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class MoreVC : UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func actionOrganizer() {
    performSegue(withIdentifier: "showOrganizerSegue", sender: "test")
  }
  
  @IBAction func actionAbout() {
    performSegue(withIdentifier: "showAboutSegue", sender: nil)
  }

  
}
