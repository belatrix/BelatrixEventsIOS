//
//  Utils.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 12/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation

struct Utils {
    struct date {
        static func getFormatter(dateString:String)->String{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            return self.newFormatFor(dateFormater.date(from: dateString)!)
        }
        
        static func getFormatterEvent(dateString:String)->String{
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
    struct data {
        static func readJsonWith(name sourceName:String) {
            guard let pathString = Bundle.main.path(forResource: sourceName, ofType: "json") else {
                fatalError("\(sourceName).json not found")
            }
            
            guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
                fatalError("Unable to convert \(sourceName).json to String")
            }
            
            print("The JSON string is: \(jsonString)")
            
            guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
                fatalError("Unable to convert \(sourceName).json to NSData")
            }
            
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject] else {
                fatalError("Unable to convert \(sourceName).json to JSON dictionary")
            }
            
            //print("The JSON dictionary is: \(jsonDictionary)")
        }
    }
}
