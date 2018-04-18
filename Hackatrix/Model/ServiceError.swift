//
//  ServiceError.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServiceError: NSObject {
    var code: Int
    var title: String
    var message: String
    var urlRequest: String
    
    // MARK: - Instance methods
    
    init(errorCode: Int, urlRequest: String, message: String) {
        self.code = errorCode
        self.urlRequest = urlRequest
        self.message = message
        self.title = ""
    }
    
    init(errorCode: Int, urlRequest: String) {
        self.code = errorCode
        self.urlRequest = urlRequest
        self.message = ""
        self.title = ""
    }
    
    override init() {
        self.code = 200
        self.urlRequest = ""
        self.title = ""
        self.message = ""
    }
    
    func printMessage() {
        print("----------------------------------------------")
        print("Error code: \(self.code)")
        print("For URL: \(self.urlRequest)")
        print("Message: \(self.message)")
        print("----------------------------------------------")
    }
}
