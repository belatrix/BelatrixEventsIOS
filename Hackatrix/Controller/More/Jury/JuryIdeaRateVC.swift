//
//  JuryIdeaRateVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/20/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

protocol JuryIdeaRateDelegate {
  
  func onJuryRated()
  
}

class JuryIdeaRateVC : UIViewController {

  var rate: Rate!
  var idea: Idea!
  var delegate: JuryIdeaRateDelegate?
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var ratePicker: UIPickerView!
  var elements = [1, 2 ,3 , 4 , 5 ,6 , 7 , 8 , 9, 10]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI(){
    categoryLabel.text = rate.categoryName
    ratePicker.showsSelectionIndicator = true
    if rate.value! > 0 {
        ratePicker.selectRow(rate.value! - 1, inComponent: 0, animated: true)
    }

  }
  
  @IBAction func cancelTap(){
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func rateTap(){
    SVProgressHUD.show()
    let valueSelected = elements[ratePicker.selectedRow(inComponent: 0)]
    ProjectManager.shared.rateIdea(ideaID: idea.id!, categoryID: rate.categoryId!, value: valueSelected, error: { (errorMessage) in
      SVProgressHUD.dismiss()
      let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }, success: {
      SVProgressHUD.dismiss()
      self.dismiss(animated: true, completion: nil)
      self.delegate?.onJuryRated()
    })
   
  }

}


extension JuryIdeaRateVC : UIPickerViewDelegate, UIPickerViewDataSource {
  
  // MARK: UIPickerView Delegation
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return elements.count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(elements[row])"
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    var attributes: [String: AnyObject]
    if row == pickerView.selectedRow(inComponent: component) {
      attributes = [
        NSForegroundColorAttributeName: UIColor.black
      ]
    } else {
      attributes = [
        NSForegroundColorAttributeName: UIColor.gray
      ]
    }
    return NSAttributedString(string: "\(self.elements[row])", attributes: attributes)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    pickerView.reloadAllComponents()
  }
  
}
