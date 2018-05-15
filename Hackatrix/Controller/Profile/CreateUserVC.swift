//
//  CreateUserVC.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/9/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    
     let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        guard let email = emailInput.text else {
            return
        }
        if emailTest.evaluate(with: email) == false {
            let alertController = UIAlertController(title: "Email Inválido", message: "Ingrese un email válido", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            createUserWithEmail(email) {
              
              let alertController = UIAlertController(title: "Cuenta creada", message: "Te enviamos la clave a tu email", preferredStyle: .alert)
              
              alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
              }))
              
              self.present(alertController, animated: true, completion: nil)
              
            }
        }
    }
    
    func createUserWithEmail(_ email: String, completion: (() -> Void)? = nil) {
      SVProgressHUD.show()
        UserManager.shared.createNewUser(email: email, error: { errorMessage in
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
