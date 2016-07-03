//
//  ProflieViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Lock
import AFNetworking

class ProfileViewController: UIViewController {
	
	let myDelay = 1.0
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var welcomeLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
		let keychain = MyApplication.sharedInstance.keychain
		let profileData:NSData! = keychain.dataForKey("profile")
		let profile:A0UserProfile = NSKeyedUnarchiver.unarchiveObjectWithData(profileData) as! A0UserProfile
		self.profileImage.setImageWithURL(profile.picture)
		self.welcomeLabel.text = "Welcome \(profile.name)!"
		if let data = myBasic.rootRef.authData {
            
            print("womp profile vc")
            print(data)
            
            myUserBackend.updateUserData("displayName", value: profile.nickname, userID: data.uid)
            myUserBackend.updateUserData("profilePicUrl", value: profile.picture.absoluteString, userID: data.uid)
            myUserBackend.updateUserData("phoneNumber", value: "12345678", userID: data.uid)
            myUserBackend.updateUserData("latitude", value: "21.2827778", userID: data.uid)
            myUserBackend.updateUserData("longitude", value: "-157.8294444", userID: data.uid)
            myUserBackend.updateUserData("karma", value: 0, userID: data.uid)
            
            myUserBackend.updateNotificationSetting("pushNotifications", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("messageNotification", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("helpMeResponseNotifcation", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("newRequestNotification", value: true, userID: data.uid)
            myUserBackend.updateNotificationSetting("requestResolvedNotification", value: true, userID: data.uid)            

			if let email = profile.email {
                myUserBackend.updateUserData("email", value: email, userID: data.uid)
			}
		}
		self.delay(myDelay) {
			self.performSegueWithIdentifier("leaveAuthSegue", sender: self)
		}
	}
	
	func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
	
}