//
//  CustomTextFieldCombo.swift
//  Hackatrix
//
//  Created by Diego Enrique Velasquez Lopez on 5/15/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class CustomTextFieldCombo : UITextField , UIGestureRecognizerDelegate{
  
  override init(frame: CGRect){
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
 /* override func layoutSubviews() {
    setup()
  }*/
  
  func setup() {
    rightViewMode = .always
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
    tapRecognizer.delegate = self
    
    let groupView = UIView(frame:CGRect(x: 0, y: 0, width: 40 , height: self.bounds.size.height))
    let imageView =  UIImageView(image: UIImage(named: "icon_arrow"))
    imageView.frame = CGRect(x: 10, y: groupView.bounds.size.height/2 - 10, width: 20 , height: 20)
    groupView.addSubview(imageView)
    groupView.isUserInteractionEnabled = true
    groupView.addGestureRecognizer(tapRecognizer)
    
    rightView = groupView
    //super.layoutSubviews()
  }
  
  func tapped(gestureRecognizer: UITapGestureRecognizer) {
    self.becomeFirstResponder()
  }
  
}
