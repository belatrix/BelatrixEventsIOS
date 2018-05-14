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

class ProfileVC: UIViewController {
    
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    var userLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginVC {
            loginVC.delegate = self
        }
    }

    @IBAction func bottomButtonPressed(_ sender: Any) {
        if (userLoggedIn) {
            //log out
            logout()
        } else {
            //create account
            performSegue(withIdentifier: K.segue.createAccount, sender: self)
        }
    }
    @IBAction func topButtonPressed(_ sender: Any) {
        if (userLoggedIn) {
            //change password
        } else {
            //log in
            performSegue(withIdentifier: K.segue.login, sender: self)
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        let token: String? = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)
      if let currentToken = token {
        UserManager.shared.profile(token: currentToken, error: {
          print ("error")
        }) {
          print ("success")
          print("email : \(UserManager.shared.currentUser?.email)")
        }
        return true
      }
      return false
    }
    
    open func setupUI() {
        topButton.layer.cornerRadius = 4
        
        if isUserLoggedIn() {
            userLoggedIn = true
            profileContainer.isHidden = false
            loginInfoLabel.isHidden = true
            topButton.setTitle("Cambiar contraseña", for: .normal)
            bottomButton.setTitle("Cerrar sesión", for: .normal)
            qrImageView.image = QRCode.generateImage("diegoveloper@gmail.com", avatarImage: nil)
        } else{
            userLoggedIn = false
            profileContainer.isHidden = true
            loginInfoLabel.isHidden = false
            topButton.setTitle("Iniciar Sesión", for: .normal)
            bottomButton.setTitle("Crear cuenta", for: .normal)
        }
    }
    
    private func logout() {
        KeychainWrapper.standard.removeObject(forKey: K.keychain.tokenKey)
        setupUI()
    }
}

extension ProfileVC: LoginDelegate {
    
    func authSuccess(_ auth: Auth) {
        setupUI()
        email.text = auth.email
        fullName.text = ""
    }
    
}
