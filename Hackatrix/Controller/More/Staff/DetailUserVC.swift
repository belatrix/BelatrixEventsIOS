//
//  DetailUserVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/20/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftQRCode

class DetailUserVC : UIViewController {
  
  var user: User!
   @IBOutlet weak var emailLabel: UILabel!
   @IBOutlet weak var fullNameLabel: UILabel!
   @IBOutlet weak var candidateLabel: UILabel!
   @IBOutlet weak var attendanceLabel: UILabel!
   @IBOutlet weak var participantLabel: UILabel!
   @IBOutlet weak var memberLabel: UILabel!
   @IBOutlet weak var qrImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadUserDetail()
  }
  
  func fillData(user: User){
    qrImageView.image = QRCode.generateImage(user.email!, avatarImage: nil)
    emailLabel.text = user.email
    fullNameLabel.text = user.fullName
    candidateLabel.text = user.candidate
    attendanceLabel.text = user.attendance
    memberLabel.text = user.member
    participantLabel.text = user.participant
  }
  
  func loadUserDetail() {
    SVProgressHUD.show()
    UserManager.shared.getUser(userID: user.id!, completion: { user in
        SVProgressHUD.dismiss()
        if let currentUser = user {
          self.fillData(user: currentUser)
        }
      })
    }
  
  
}
