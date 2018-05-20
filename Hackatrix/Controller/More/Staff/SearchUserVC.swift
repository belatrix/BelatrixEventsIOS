//
//  SearchUserVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SearchUserVCDelegate {
  
  func onUserSelected(user: User)
  
}

class SearchUserVC : UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var isFromAddParticipant = false
  var idea: Idea?
  var delegate: SearchUserVCDelegate?
  var elements: [User] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if isFromAddParticipant {
      self.title = "Agregar Participante"
    }
  }
  
  func searchUsers(criteria: String) {
    SVProgressHUD.show()
    UserManager.shared.getUserList(search: criteria, completion: { userList in
        SVProgressHUD.dismiss()
       self.elements = userList
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.segue.userDetail {
      let dvc = segue.destination as! DetailUserVC
      dvc.user = sender as! User
    }
  }
}

extension SearchUserVC: UISearchBarDelegate {
  

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let currentText = searchBar.text {
      if currentText.count > 2 {
        self.searchUsers(criteria: currentText)
      } else {
        let alertController = UIAlertController(title: "Error", message: "Debe ingresar por lo menos 3 letras", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        elements = [User]()
      }
    }
    searchBar.resignFirstResponder()
  }
  
  func onSelectUser (user: User){
    let alertController = UIAlertController(title: "Hackatrix", message: "Desea agregar a \(user.email!) para la idea de : \(idea!.title ?? "") ?", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in
      self.delegate?.onUserSelected(user: user)
      self.navigationController?.popViewController(animated: true)
    }))
    self.present(alertController, animated: true, completion: nil)
    
  }
  
}


extension SearchUserVC: UITableViewDataSource , UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user  = elements[indexPath.row]
    if isFromAddParticipant {
      onSelectUser(user: user)
    } else {
      performSegue(withIdentifier: K.segue.userDetail, sender: user)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
    let user  = elements[indexPath.row]
    cell.textLabel?.text =  user.email
    cell.detailTextLabel?.text = user.fullName
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
}
