//
//  AddNewIdeaVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

protocol AddNewIdeaDelegate: class {
    func complete()
}
class AddNewIdeaVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    var eventId: Int?
    weak var delegate: AddNewIdeaDelegate?
    
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
        }){ [weak self] (idea) in
            //idea created
            let alertController = UIAlertController(title: "", message: "La idea fue ingresada exitosamente y será revisada por los moderadores en breve.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                self?.delegate?.complete()
                self?.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(defaultAction)
            self?.present(alertController, animated: true, completion: nil)
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
