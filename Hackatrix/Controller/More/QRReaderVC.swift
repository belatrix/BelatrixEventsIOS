//
//  QRReaderVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/13/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftQRCode

class QRReaderVC : UIViewController {
  
  let scanner = QRCode()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scanner.prepareScan(view) { (stringValue) -> () in
      print(stringValue)
    }
    scanner.scanFrame = view.bounds
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scanner.startScan()
  }
  
}
