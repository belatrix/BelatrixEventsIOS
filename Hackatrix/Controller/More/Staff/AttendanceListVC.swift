//
//  AttendanceListVC.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class AttendanceListVC : UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var elements: [Meeting] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMeetingList()
  }
  
  func getMeetingList() {
    SVProgressHUD.show()
    let token: String = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)!
    EventManager.shared.getMeetingList(token: token, error: { errorMessage in
      print("error")
      SVProgressHUD.dismiss()
    }) {(meetingList) in
      SVProgressHUD.dismiss()
      self.elements = meetingList
    
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.segue.qrReader {
      let dvc = segue.destination as! QRReaderVC
      dvc.meeting = sender as! Meeting
    }
  }
}


extension AttendanceListVC: UITableViewDataSource , UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meeting  = elements[indexPath.row]
        performSegue(withIdentifier: K.segue.qrReader, sender: meeting)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "eventRegisterCell", for: indexPath)
    let meeting  = elements[indexPath.row]
    cell.textLabel?.text = meeting.name
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
}
