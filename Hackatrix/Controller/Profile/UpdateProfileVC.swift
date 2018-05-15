//
//  UpdateProfileVC.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdateProfileVC: UIViewController {
  
  @IBOutlet weak var fullNameInput: UITextField!
  @IBOutlet weak var phoneInput: UITextField!{
    didSet { phoneInput?.addDoneCancelToolbar() }
  }
  @IBOutlet weak var roleInput: UITextField! {
    didSet { roleInput?.addDoneCancelToolbar() }
  }
  let myPickerData = [String](arrayLiteral: "Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy")
  
  let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let thePicker = UIPickerView()
    thePicker.delegate = self
    roleInput.inputView = thePicker
  }
  
  @IBAction func updateProfilePressed(_ sender: Any) {
    /*
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
    }*/
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
    return myPickerData.count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return myPickerData[row]
  }
  
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    roleInput.text = myPickerData[row]
  }
}
