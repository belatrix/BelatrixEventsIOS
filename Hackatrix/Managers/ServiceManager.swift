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
    
        let tokenFromLocal: String? = KeychainWrapper.standard.string(forKey: K.keychain.tokenKey)
        var headers : HTTPHeaders?
        if let customToken = tokenFromLocal {
          if self.debugLog {
            print("token: \(customToken)")
          }
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
  
    
}
