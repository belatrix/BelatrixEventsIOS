//
//  AddNewIdeaVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class AddNewIdeaVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    var eventId: Int?
    
    //MARK: - IBActions

    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func donePressed(_ sender: Any) {
        //TODO: Call save idea method and go back on completion
      createIdea()
    }
    //MARK: - Private

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createIdea() {
        guard let title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines), let eventId = eventId else {
            let alertController = UIAlertController(title: "Inválido", message: "Por favor ingrese un tíltulo correcto", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let description = txtDescription.text ?? ""
        
        ProjectManager.shared.createIdea(eventID: eventId, title: title, description: description, error: { [weak self] in
            //something wents wrong
            let alertController = UIAlertController(title: "Error", message: "No se puedo ingresar la idea correctamente", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self?.present(alertController, animated: true, completion: nil)
        }){ (idea) in 
            //idea created
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddNewIdeaVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Descripción breve") {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Descripción"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
