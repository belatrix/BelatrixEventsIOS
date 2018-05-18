//
//  ModeratorIdeaListVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/16/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class ModeratorIdeaListVC : UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: UILabel!
  var event: Event!
  var elements: [Idea] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = event.title
    getIdeaList()
  }
  
  func getIdeaList() {
    SVProgressHUD.show()
    ProjectManager.shared.getIdeas(eventID: event.id!) {(ideaList) in
      SVProgressHUD.dismiss()
      self.elements = ideaList
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.segue.moderatorIdeaDetail {
      let dvc = segue.destination as! ProjectDetailVC
      dvc.isFromModarator = true
      dvc.idea = sender as! Idea
    }
  }
}


extension ModeratorIdeaListVC: UITableViewDataSource , UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let idea  = elements[indexPath.row]
    performSegue(withIdentifier: K.segue.moderatorIdeaDetail, sender: idea)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ideaCell", for: indexPath)
    let idea  = elements[indexPath.row]
    cell.textLabel?.text = idea.title
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
}
