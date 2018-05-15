//
//  Constants.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 16/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation

struct K {
    struct url {
        static let belatrix = "http://belatrixsf.com"
    }
    struct  email {
        static let contact = "mobilelab@belatrixsf.com"
    }
    struct segue {
        static let settings = "settingsSegue"
        static let news = "newsSegue"
        static let about = "aboutSegue"
        static let detail = "detailSegue"
        static let map = "mapSegue"
        static let citySetting = "citySettingSegue"
        static let selectCity = "selectCitySegue"
        static let newIdea = "newIdeaSegue"
        static let project = "projectSegue"
        static let login = "loginSegue"
        static let createAccount = "createAccountSegue"
        static let  forgotPassword = "forgotPasswordSegue"
    }
    struct cell {
        static let menu = "itemMenuCell"
        static let event = "eventCell"
        static let setting = "settingCell"
        static let news = "newsCell"
        static let contributor = "contributorCell"
        static let interaction = "interactionCell"
        static let location = "locationCell"
    }
    struct key {
        static let showedWelcomeAlertInteraction = "isShowedWelcomeAlertInteraction"
        static let interactionForAProject = "isInteractionForAProject"
    }
    
    struct keychain {
        static let tokenKey = "token"
    }
}
