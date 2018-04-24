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

    //MARK: - IBActions

    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func donePressed(_ sender: Any) {
        //TODO: Call save idea method and go back on completion
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Private

    override func viewDidLoad() {
        super.viewDidLoad()
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
