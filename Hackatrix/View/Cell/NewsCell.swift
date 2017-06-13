//
//  NewsCell.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 12/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = .zero
    }

}
