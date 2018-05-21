//
//  StaffVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/17/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import PTPopupWebView

class StaffVC : UIViewController {

  @IBAction func actionReports() {
    let popupvc = PTPopupWebViewController()
    let urlString = "http://bxevents.herokuapp.com/reports/"
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
