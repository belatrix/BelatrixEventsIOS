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
    let debugLog = true
  
  func useService(url: String, method: HTTPMethod, parameters: Parameters?, token: String? = nil,  completion: ((_ response: JSON?) -> Void)? = nil ){
    useService(url: url, method: method, parameters: parameters, token: token , completion: completion , result: nil)
  }
    
  func useService(url: String, method: HTTPMethod, parameters: Parameters?, token: String? = nil,  completion: ((_ response: JSON?) -> Void)? = nil,
                  result: ((_ response: JSON?, _ error: String? ) -> Void)? = nil
                  ) {
        var headers : HTTPHeaders?
        if let customToken = token {
          headers = [
          "Authorization": "Token \(customToken)"
          ]
        }
    Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON { response in
                if self.debugLog {
                    print(url)
                    print(parameters)
                }
                let responseServer = response.result.value
                if let code = response.response?.statusCode {
                  if self.debugLog {
                    print(responseServer)
                  }
                  
                    switch code {
                    case 200, 201 , 202:
                        let json = JSON(responseServer)
                        if let currentResult = result {
                           currentResult(json, nil)
                        } else {
                           completion?(json)
                        }
                       
                        break
                    default:
                         let json = JSON(responseServer)
                         let message =  json["detail"].stringValue
                         ServiceError(errorCode: code, urlRequest: url, message:message).printMessage()
                         if let currentResult = result {
                            currentResult(nil, message)
                         } else {
                            completion?(nil)
                         }
                        break
                    }
                } else {
                  
                   if self.debugLog {
                    print("error : \(response.response)")
                  }
                  if let currentResult = result {
                    currentResult(nil, "error inesperado")
                  } else {
                    completion?(nil)
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
