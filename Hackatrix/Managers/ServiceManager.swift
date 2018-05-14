//
//  ServiceManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    var sessionManager: Alamofire.SessionManager?
    
    func useService(url: String, method: HTTPMethod, parameters: Parameters?, completion: ((_ response: JSON?) -> Void)? = nil) {
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if let completion = completion {
                if let responseServer = response.result.value, let code = response.response?.statusCode {
                    switch response.result {
                    case .success:
                        let json = JSON(responseServer)
                        completion(json)
                        break
                    case .failure(_):
                        ServiceError(errorCode: code, urlRequest: url).printMessage()
                        completion(nil)
                        break
                    }
                } else {
                    if let code = response.response?.statusCode {
                        ServiceError(errorCode: code, urlRequest: url).printMessage()
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func useAuthService(url: String, method: HTTPMethod, parameters: Parameters?, completion: ((_ response: JSON?) -> Void)? = nil) {
        
        if  sessionManager == nil {
            // get the default headers
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            let token = Utils.auth.getToken()
            headers["Authorization"] = "Token \(token)"
            // create a custom session configuration
            let configuration = URLSessionConfiguration.default
            // add the headers
            configuration.httpAdditionalHeaders = headers
            // create a session manager with the configuration
            self.sessionManager = Alamofire.SessionManager(configuration: configuration)
        }
       
        sessionManager?.request(url, method: method, parameters: parameters).validate().responseJSON { response in
            if let completion = completion {
                if let responseServer = response.result.value, let code = response.response?.statusCode {
                    switch response.result {
                    case .success:
                        let json = JSON(responseServer)
                        completion(json)
                        break
                    case .failure(_):
                        ServiceError(errorCode: code, urlRequest: url).printMessage()
                        completion(nil)
                        break
                    }
                } else {
                    if let code = response.response?.statusCode {
                        ServiceError(errorCode: code, urlRequest: url).printMessage()
                    }
                    completion(nil)
                }
            }
        }
    }
    
}
