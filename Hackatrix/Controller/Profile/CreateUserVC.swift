//
//  CreateUserVC.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/9/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    
     let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dondePressed(_ sender: Any) {
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
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createUserWithEmail(_ email: String, completion: (() -> Void)? = nil) {
        UserManager.shared.createNewUser(email: email, error: { [weak self] in
            let alertController = UIAlertController(title: "Error", message: "No se pudo crear la cuenta", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self?.present(alertController, animated: true, completion: nil)
        }) {(user) in
            if let completion = completion {
                completion()
            }
        }
    }
}
