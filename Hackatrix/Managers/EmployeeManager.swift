//
//  EmployeeManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/19/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class EmployeeManager: NSObject {
    static let shared = EmployeeManager()
    let serviceManager = ServiceManager.shared

    func getEmployee(employeeID: Int, completion: ((_ employee: Employee) -> Void)? = nil) {
        self.serviceManager.useService(url: api.url.employeeWith(employeeID), method: .get, parameters: nil) { (json) in
            if let json = json {
                if let completion = completion {
                    completion(Employee(data: json))
                }
            }
        }
    }
}
