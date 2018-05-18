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
  @IBOutlet weak var moderatorConstraint : NSLayoutConstraint!
  @IBOutlet weak var ideasConstraint : NSLayoutConstraint!
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
       staffConstraint.constant = user.isStaff! ? constantHeight : 0
       moderatorConstraint.constant = user.isModerator! ? constantHeight : 0
       ideasConstraint.constant = constantHeight
    } else {
       staffConstraint.constant = 0
       moderatorConstraint.constant = 0
       ideasConstraint.constant = 0
    }
  }
  
  @IBAction func actionHelp() {
    if let url = URL(string: "http://hackatrix.belatrixsf.com/") {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:])
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
 
}
