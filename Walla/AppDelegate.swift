//
//  AppDelegate.swift
//  Walla
//
//  Created by Timothy Choh on 6/23/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

    override init() {
        super.init()
        FIRApp.configure()
        FIRAuth.auth()?.createUserWithEmail("womp@womp.com", password: "wompwomp") { (user, error) in
            print(user)
            print(error)
        }
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }
    
    // Temporary method with all the hardcoded auth calls
    func hardCodedLogin() {
        let tempEmail = "womp@womp.com"
        let tempPass = "womp"
        let myUserBackend = UserBackend()
//        myUserBackend.nativeCreateUser(tempEmail, password: tempPass)
        myUserBackend.nativeLogin(tempEmail, password: tempPass)
        safeToLoadID = true
        myUserBackend.updateUserData("karma", value: 0, userID: "v5G0djFGreTJ2WcEwd7bEbIlZzP2")
        if let data = FIRAuth.auth()?.currentUser {
            var displayName = "womp"
            var name = "womp"
            var profilePicUrl = "http://media.npr.org/assets/img/2016/03/29/ap_090911089838_sq-3271237f28995f6530d9634ff27228cae88e3440-s900-c85.jpg"
            
            myUserBackend.updateUserData("displayName", value: displayName, userID: data.uid)
            myUserBackend.updateUserData("name", value: name, userID: data.uid)
            myUserBackend.updateUserData("profilePicUrl", value: profilePicUrl, userID: data.uid)
            myUserBackend.updateUserData("phoneNumber", value: "12345678", userID: data.uid)
            myUserBackend.updateUserData("latitude", value: 36.0014, userID: data.uid)
            myUserBackend.updateUserData("longitude", value: 78.9382, userID: data.uid)
            myUserBackend.updateUserData("karma", value: 0, userID: data.uid)
            
            myUserBackend.updateNotificationSetting("pushNotifications", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("messageNotification", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("helpMeResponseNotifcation", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("newRequestNotification", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("requestResolvedNotification", value: true, userID: data.uid)
        }
        
    }

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

