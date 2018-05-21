//
//  CustomWhiteButton.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/14/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class CustomWhiteButton : UIButton {
  
  override init(frame: CGRect){
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    setup()
  }
  
  func setup() {
    let customColor = UIColor(red: 31/255, green: 72/255, blue: 145/255, alpha: 1.0)
    self.layer.borderColor = customColor.cgColor
    self.layer.borderWidth = 1
    super.layoutSubviews()
  }
  
}
