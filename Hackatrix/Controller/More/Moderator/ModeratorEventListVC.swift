//
//  ModeratorEventListVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/16/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class ModeratorEventListVC : UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var isFromModarator = false
  var elements: [Event] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getEventList()
  }
  
  func getEventList() {
    SVProgressHUD.show()
    EventManager.shared.getEvents(){ eventList in
      SVProgressHUD.dismiss()
       self.elements = eventList
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.segue.moderatorIdeas {
      let dvc = segue.destination as! ModeratorIdeaListVC
      dvc.event = sender as! Event
    }
  }
}


extension ModeratorEventListVC: UITableViewDataSource , UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let event  = elements[indexPath.row]
    performSegue(withIdentifier: K.segue.moderatorIdeas, sender: event)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
    let event  = elements[indexPath.row]
    cell.textLabel?.text = event.title
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
}
