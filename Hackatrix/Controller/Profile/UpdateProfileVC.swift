//
//  UpdateProfileVC.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

protocol UpdateProfileDelegate  {
  
    func onUserUpdated()
}

class UpdateProfileVC: UIViewController {
  
  var updateProfileDelegate : UpdateProfileDelegate?
  @IBOutlet weak var fullNameInput: UITextField!
  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phoneInput: UITextField!{
    didSet { phoneInput?.addDoneCancelToolbar() }
  }
  @IBOutlet weak var roleInput: UITextField! {
    didSet { roleInput?.addDoneCancelToolbar() }
  }
  
  var currentUser : User  {
    return UserManager.shared.currentUser!
  }
  
  let thePicker = UIPickerView()
  var elements: [Role] = [] {
    didSet {
      thePicker.reloadAllComponents()
    }
  }
  var roleSelected : Role?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    thePicker.delegate = self
    roleInput.inputView = thePicker
    setupViews()
    loadRoles()
  }
  
  func setupViews(){
    let user = currentUser
    fullNameInput.text = user.fullName
    phoneInput.text = user.phoneNumber
    emailLabel.text = user.email
    if let currentRole = user.role {
      roleInput.text = currentRole.name
      roleSelected = currentRole
    }
    validateInputs()
  }
  
  func loadRoles(){
     SVProgressHUD.show()
    let token: String = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)!
    UserManager.shared.getRoles(token: token, error: { errorMessage in
      print("error")
      SVProgressHUD.dismiss()
    }) {(roles) in
      SVProgressHUD.dismiss()
      
      self.elements = roles
      if self.roleSelected == nil {
          self.roleSelected = roles[0]
        self.thePicker.selectRow(0, inComponent: 0, animated: true)
        } else {
        self.thePicker.selectRow((self.roleSelected!.id - 1), inComponent: 0, animated: true)
      }
     
      /*
      let role1 = Role(_id: 1, _name: "Backend dev")
      let role2 = Role(_id: 2, _name: "Mobile dev")
      let role3 = Role(_id: 3, _name: "QA tester")
      self.elements = [role1, role2, role3]*/
    }
  }
  
  @IBAction func textFieldDidChange(_ textField: UITextField) {
    validateInputs()
  }
  
  func validateInputs(){
    /*
    guard let fullName = fullNameInput.text else {
      updateButton.isEnabled = false
      return
    }
    if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
      updateButton.isEnabled = false
      return
    }
    
    guard let phoneNumber = phoneInput.text else {
      updateButton.isEnabled = false
      return
    }
    if phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
      updateButton.isEnabled = false
      return
    }
    
    guard let role = roleInput.text else {
      updateButton.isEnabled = false
      return
    }
    if role.trimmingCharacters(in: .whitespaces).isEmpty {
      updateButton.isEnabled = false
      return
    }
    */
    updateButton.isEnabled = true
  }
  
  @IBAction func updateProfilePressed(_ sender: Any) {
      updateUserProfile() {
        
        let alertController = UIAlertController(title: "Hackatrix", message: "Perfil actualizado", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          self.updateProfileDelegate?.onUserUpdated()
          self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
      }
  }
  
  func updateUserProfile( completion: (() -> Void)? = nil) {
    SVProgressHUD.show()
     let token: String = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)!
    UserManager.shared.updateUser(token: token, fullName: fullNameInput.text!, phoneNumber: phoneInput.text! , roleId: roleSelected!.id, error: { errorMessage in
      let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      SVProgressHUD.dismiss()
    }) {(user) in
      SVProgressHUD.dismiss()
      if let completion = completion {
        completion()
      }
    }
  }
}

extension UpdateProfileVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension UpdateProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
  
  // MARK: UIPickerView Delegation
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return elements.count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return elements[row].name
  }
  
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    roleSelected = elements[row]
    roleInput.text = elements[row].name
  }
}
