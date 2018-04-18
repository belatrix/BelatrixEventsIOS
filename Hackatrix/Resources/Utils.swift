//
//  Utils.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 12/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Utils {
    struct date {
        static func getFormatter(dateString:String) -> String {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            if let date = dateFormater.date(from: dateString) {
                return self.newFormatFor(date)
            }
            return ""
        }
        
        static func getFormatterEvent(dateString:String) -> String {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormater.date(from: dateString) {
                return self.newFormatFor(date)
            }
            return ""
        }
        
        private static func newFormatFor(_ date:Date) -> String {
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "dd/MM/yy hh:mm a"
            newDateFormat.locale = Locale(identifier: "es_PE")
            return newDateFormat.string(from: date)
        }
    }
}
