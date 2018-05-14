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

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    let debugLog = true
    
  func useService(url: String, method: HTTPMethod, parameters: Parameters?, token: String? = nil,  completion: ((_ response: JSON?) -> Void)? = nil) {
    
        var headers : HTTPHeaders?
        if let customToken = token {
          headers = [
          "Authorization": "Token \(customToken)"
          ]
        }
    Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON { response in
            if let completion = completion {
                if self.debugLog {
                    print(url)
                    print(parameters)
                }
              
                if let responseServer = response.result.value, let code = response.response?.statusCode {
                  if self.debugLog {
                    print(responseServer)
                  }
                  
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
                  
                   if self.debugLog {
                    print("error : \(response.response)")
                  }
                    if let code = response.response?.statusCode {
                        ServiceError(errorCode: code, urlRequest: url).printMessage()
                    }
                    completion(nil)
                }
            }
        }
    }
}
