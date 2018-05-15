//
//  ProfileVC.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/9/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftQRCode
import SVProgressHUD

class ProfileVC: UIViewController {

    @IBOutlet weak var loginContainer: UIScrollView!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    //@IBOutlet var editBarButtonItem: UIBarButtonItem!
  
    var currentUser : User?  {
        return UserManager.shared.currentUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // editBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editButtonPressed(_:)))
        setupUI(fromRefresh: false)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
      guard let username = emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordInput.text, username.count > 0, password.count > 0 else {
        return
      }
      
      SVProgressHUD.show()
      authenticate(username: username, password: password) {(auth) in
        if let token = auth.token {
          KeychainWrapper.standard.set(token, forKey: K.keychain.tokenKey)
          self.refreshProfile()
        }
      }
  }
  
  @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
      performSegue(withIdentifier: K.segue.forgotPassword, sender: self)
  }
  
  @IBAction func editButtonPressed(_ sender: Any) {
    print("go to edit")
  }
  
  func authenticate(username: String, password: String, completion: ((_ auth: Auth) -> Void)? = nil) {
    UserManager.shared.authenticate(username: username, password: password, error: { [weak self] in
      SVProgressHUD.dismiss()
      let alertController = UIAlertController(title: "Error", message: "Email/Contraseña incorrectos", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self?.present(alertController, animated: true, completion: nil)
    }){ (auth) in
      if let completion = completion {
        self.emailInput.resignFirstResponder()
        self.passwordInput.resignFirstResponder()
        completion(auth)
        SVProgressHUD.dismiss()
      }
    }
  }
  
    @IBAction func createButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: K.segue.createAccount, sender: self)
    }
  
  @IBAction func updateProfileButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: K.segue.updateProfile, sender: self)
  }
  
  @IBAction func logOutButtonPressed(_ sender: Any) {
    SVProgressHUD.show()
     let token: String = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)!
    UserManager.shared.logout(token: token, error: { () in
      SVProgressHUD.dismiss()
      KeychainWrapper.standard.removeObject(forKey: K.keychain.tokenKey)
      self.setupUI(fromRefresh: false)
    }){ () in
        KeychainWrapper.standard.removeObject(forKey: K.keychain.tokenKey)
        SVProgressHUD.dismiss()
     self.setupUI(fromRefresh: false)
    }
  }
    
    private func refreshProfile()  {
        let token: String? = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)
      if let currentToken = token {
        UserManager.shared.profile(token: currentToken, error: {
          print ("error")
           SVProgressHUD.dismiss()
        }) {
          print ("success")
          self.setupUI(fromRefresh: true)
           SVProgressHUD.dismiss()
        }
      }
    }
    
    open func setupUI(fromRefresh: Bool) {
        if let user  = currentUser {
            emailInput.text =  ""
            passwordInput.text = ""
            //self.navigationItem.rightBarButtonItem = self.editBarButtonItem
            loginContainer.isHidden = true
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
               self.profileContainer.isHidden = false
            })
            fullName.text = user.fullName
            email.text = user.email
            role.text = user.role
            phone.text = user.phoneNumber
            qrImageView.image = QRCode.generateImage(user.email!, avatarImage: nil)
          if !fromRefresh {
            refreshProfile()
          }
        } else{
          //self.navigationItem.rightBarButtonItem = nil
          profileContainer.isHidden = true
          UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
             self.loginContainer.isHidden = false
          })
        }
    }
  
}

extension ProfileVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

