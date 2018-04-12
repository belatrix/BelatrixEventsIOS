//
//  NewsManager.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/12/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsManager: NSObject {
    static let shared = NewsManager()
    let serviceManager = ServiceManager.shared
    
    func getNews(completion: ((_ news: [News]) -> Void)? = nil) {
        serviceManager.useService(url: api.url.notifications.all, method: .get, parameters: nil) { (json) in
            var news: [News] = []
            if let json = json {
                for (_, subJson): (String, JSON) in json {
                    news.append(News(data: subJson))
                }
                if let completion = completion {
                    completion(news)
                }
            }
        }
    }
}
