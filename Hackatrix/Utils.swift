//
//  Utils.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 12/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation

class Utils {
    static func getFormatterDate(dateString:String)->String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return self.newFormatFor(dateFormater.date(from: dateString)!)
    }
    
    static func getFormatterDateEvent(dateString:String)->String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return self.newFormatFor(dateFormater.date(from: dateString)!)
        
    }

    private static func newFormatFor(_ date:Date) -> String {
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "dd/MM/yy hh:mm a"
        newDateFormat.locale = Locale(identifier: "es_PE")
        newDateFormat.timeZone = TimeZone(identifier: "UTC")
        return newDateFormat.string(from: date)
    }
}
