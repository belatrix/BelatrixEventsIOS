//
//  LoginVC.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/9/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol LoginDelegate: class {
    func authSuccess(_ auth: Auth)
}

class LoginVC: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    weak var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func donePressed(_ sender: Any) {
        guard let username = emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordInput.text, username.count > 0, password.count > 0 else {
            return
        }
        authenticate(username: username, password: password) {(auth) in
            if let token = auth.token {
                KeychainWrapper.standard.set(token, forKey: K.keychain.tokenKey)
                self.delegate?.authSuccess(auth)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func authenticate(username: String, password: String, completion: ((_ auth: Auth) -> Void)? = nil) {
        UserManager.shared.authenticate(username: username, password: password, error: { [weak self] in
            let alertController = UIAlertController(title: "Error", message: "No se pudo autenticar", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self?.present(alertController, animated: true, completion: nil)
        }){ (auth) in
            if let completion = completion {
                completion(auth)
            }
        }
    }
}
