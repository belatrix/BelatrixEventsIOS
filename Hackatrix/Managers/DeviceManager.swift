//
//  DeviceManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class DeviceManager: NSObject {
    static let shared = DeviceManager()
    let serviceManager = ServiceManager.shared

    func registerDevice(fcmToken: String, completion: (() -> Void)? = nil) {
        serviceManager.useService(url: api.url.device.register, method: .post, parameters: ["device_code":fcmToken]) { (json) in
            if let json = json {
                print("Register Device JSON: \(json)")
            }
        }
    }
}