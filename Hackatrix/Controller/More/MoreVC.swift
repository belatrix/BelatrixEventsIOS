//
//  MoreVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/13/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import PTPopupWebView

class MoreVC : UIViewController {
  
  @IBOutlet weak var staffConstraint : NSLayoutConstraint!
  @IBOutlet weak var moderatorConstraint : NSLayoutConstraint!
  @IBOutlet weak var ideasConstraint : NSLayoutConstraint!
  @IBOutlet weak var juryConstraint : NSLayoutConstraint!
  let constantHeight : CGFloat = 70.0
  
  var currentUser : User?  {
    return UserManager.shared.currentUser
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func refreshTab(notification: NSNotification) {
    self.navigationController?.popToRootViewController(animated: false)
    viewDidAppear(false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("user:  \(currentUser?.email)")
    setupViews()
    NotificationCenter.default.addObserver(self, selector: #selector(refreshTab(notification:)), name: .notification_more, object: nil)
  }
  
  func setupViews(){
    if let user = currentUser {
       staffConstraint.constant = user.isStaff! ? constantHeight : 0
       moderatorConstraint.constant = user.isModerator! ? constantHeight : 0
       juryConstraint.constant = user.isJury! ? constantHeight : 0
       ideasConstraint.constant = constantHeight
    } else {
       staffConstraint.constant = 0
       moderatorConstraint.constant = 0
       ideasConstraint.constant = 0
       juryConstraint.constant = 0
    }
  }
  
  @IBAction func actionHelp() {
    let popupvc = PTPopupWebViewController()
    let urlString = "http://hackatrix.belatrixsf.com/"
    popupvc.popupView.URL(string: urlString)
      // add custom action button
      .addButton(
        PTPopupWebViewButton(type: .custom)
          .title("Abrir en safari").handler() {
            if let url = URL(string: urlString) {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
              } else {
                UIApplication.shared.openURL(url)
              }
            }
      })
      .addButton(PTPopupWebViewButton(type: .close).title("Cerrar"))
    popupvc.show()
  }
 
}
