//
//  MoreVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/13/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class MoreVC : UIViewController {
  
  @IBOutlet weak var staffConstraint : NSLayoutConstraint!
  let constantHeight : CGFloat = 70.0
  
  var currentUser : User?  {
    return UserManager.shared.currentUser
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("user:  \(currentUser?.email)")
    setupViews()
  }
  
  func setupViews(){
    if let user = currentUser {
      if user.isStaff! {
        staffConstraint.constant = constantHeight
      } else {
        staffConstraint.constant = 0
      }
    } else {
      staffConstraint.constant = 0
    }
  }
  
  @IBAction func actionOrganizer() {
    performSegue(withIdentifier: "showStaffSegue", sender: "test")
  }
  
  @IBAction func actionAbout() {
    performSegue(withIdentifier: "showAboutSegue", sender: nil)
  }

  
}
