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
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    var currentUser : User?  {
        return UserManager.shared.currentUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
  
  func authenticate(username: String, password: String, completion: ((_ auth: Auth) -> Void)? = nil) {
    UserManager.shared.authenticate(username: username, password: password, error: { [weak self] in
      SVProgressHUD.dismiss()
      let alertController = UIAlertController(title: "Error", message: "Email/Contraseña incorrectos", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self?.present(alertController, animated: true, completion: nil)
    }){ (auth) in
      if let completion = completion {
        completion(auth)
        SVProgressHUD.dismiss()
      }
    }
  }
  
    @IBAction func createButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: K.segue.createAccount, sender: self)
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
            loginContainer.isHidden = true
            profileContainer.isHidden = false
            fullName.text = user.fullName
            email.text = user.email
            qrImageView.image = QRCode.generateImage(user.email!, avatarImage: nil)
          if !fromRefresh {
            refreshProfile()
          }
        } else{
          loginContainer.isHidden = false
          profileContainer.isHidden = true
        }
    }
    
    private func logout() {
        KeychainWrapper.standard.removeObject(forKey: K.keychain.tokenKey)
        //setupUI()
    }
}

