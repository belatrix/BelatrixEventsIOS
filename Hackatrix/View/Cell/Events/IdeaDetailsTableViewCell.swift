//
//  IdeaDetailsTableViewCell.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/16/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class IdeaDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var ideaDescription: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorEmail: UILabel!
    @IBOutlet weak var authorPhoneNumber: UILabel!
    @IBOutlet weak var authorRole: UILabel!
    
}

class IdeaValidationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ideaValidSwitch: UISwitch!
    
}
