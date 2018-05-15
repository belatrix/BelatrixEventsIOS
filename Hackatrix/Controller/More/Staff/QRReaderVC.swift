//
//  QRReaderVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/13/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftQRCode
import SVProgressHUD
import SwiftKeychainWrapper

class QRReaderVC : UIViewController {
  
  let scanner = QRCode()
  var meeting : Meeting!
  @IBOutlet weak var scanView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  var isSimulator : Bool {
     return TARGET_OS_SIMULATOR != 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if !isSimulator {
      scanner.prepareScan(scanView) { (stringValue) -> () in
        print(stringValue)
      }
    }
    scanner.scanFrame = scanView.bounds
    
    nameLabel.text = meeting.name
    print("MEETTING ID : \(meeting.id)")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  
  }
  
  func startScanning(){
    if !isSimulator {
      scanner.startScan()
    }
  }
  
  func stopScanning(){
    if !isSimulator {
      scanner.stopScan()
    }
  }
  
  func registerAttendance(email: String) {
    stopScanning()
    SVProgressHUD.show()
     let token: String = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)!
    EventManager.shared.registerAttendance(token: token, email: email, meetingId: meeting.id, error: { errorMessage in
      let alertController = UIAlertController(title: "Error", message: "\(email): \(errorMessage)", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {  action in
         self.startScanning()
      }))
      self.present(alertController, animated: true, completion: nil)
      SVProgressHUD.dismiss()
    }) {(user) in
      self.startScanning()
      SVProgressHUD.dismiss()
      
      let alertController = UIAlertController(title: "Hackatrix", message: "\(user.email!) registrado satisfactoriamente", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {  action in
       self.startScanning()
      }))
        self.present(alertController, animated: true, completion: nil)
        SVProgressHUD.dismiss()
      
      
    }
  }
  
}
