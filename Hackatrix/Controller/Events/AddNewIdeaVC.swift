//
//  AddNewIdeaVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol AddNewIdeaDelegate: class {
    func complete(idea: Idea)
}
class AddNewIdeaVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    var eventId: Int?
    weak var delegate: AddNewIdeaDelegate?
    var idea: Idea?
    
    //MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func donePressed(_ sender: Any) {
        createOrEditIdea()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let idea = idea {
            txtTitle.text = idea.title
            txtDescription.text = idea.ideaDescription
            navigationItem.title = "Editar idea"
        }
    }
    
    //MARK: - Private
    private func createOrEditIdea() {
        guard let title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            let alertController = UIAlertController(title: "Inválido", message: "Por favor ingrese un tíltulo correcto", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let description = txtDescription.text ?? ""
        
        if let idea = idea, let ideaId = idea.id {
            SVProgressHUD.show()
            //edit idea mode
            ProjectManager.shared.editIdea(ideaId: ideaId, title: title, description: description, error: { [weak self](error) in
                SVProgressHUD.dismiss()
                //something wents wrong
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            }) { [weak self] (idea) in
                SVProgressHUD.dismiss()
                //idea created
                self?.delegate?.complete(idea: idea)
                self?.navigationController?.popViewController(animated: true)
            }
        } else if let eventId = eventId {
            SVProgressHUD.show()
            //create idea mode
            ProjectManager.shared.createIdea(eventID: eventId, title: title, description: description, error: { [weak self](error) in
                SVProgressHUD.dismiss()
                //something wents wrong
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            }){ [weak self] (idea) in
                SVProgressHUD.dismiss()
                //idea created
                let alertController = UIAlertController(title: "", message: "La idea fue ingresada exitosamente y será revisada por los moderadores en breve.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                    self?.delegate?.complete(idea: idea)
                    self?.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            }
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
