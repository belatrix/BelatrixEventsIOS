//
//  AppDelegate.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 8/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var userDefaults = UserDefaults.standard
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        if userDefaults.object(forKey: K.key.showedWelcomeAlertInteraction) == nil {
            self.userDefaults.set(true, forKey: K.key.showedWelcomeAlertInteraction)
        }
        if userDefaults.object(forKey: K.key.interactionForAProject) == nil {
            self.userDefaults.set(false, forKey: K.key.interactionForAProject)
        }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotification(notification:)),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = InstanceID.instanceID().token()
        if let token = refreshedToken {
            if token != "" {
                self.registerDeviceInBackEndWith(token)
            }
        }
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error ?? "no error" as! Error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func registerDeviceInBackEndWith(_ fcmToken:String) {
        DeviceManager.shared.registerDevice(fcmToken: fcmToken  )
    }
}

extension AppDelegate: MessagingDelegate {
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        print("userinfo \(userInfo)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}

