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
			myUserBackend.updateDisplayName(profile.nickname, userID: data.uid)
			myUserBackend.updateProfilePicUrl(profile.picture.absoluteString, userID: data.uid)
			myUserBackend.updatePhoneNumber("12345678", userID: data.uid)
			myUserBackend.updateNotifications(data.uid)
			if let email = profile.email {
				myUserBackend.updateEmail(email, userID: data.uid)
			}
		}
		self.delay(myDelay) {
			self.performSegueWithIdentifier("leaveAuthSegue", sender: self)
		}
	}
	
	@IBAction func callAPI(sender: AnyObject) {
		let request = buildAPIRequest()
		let operation = AFHTTPRequestOperation(request: request)
		operation.setCompletionBlockWithSuccess(
			
			{ (operation, responseObject) -> Void in
				self.showMessage("We got the secured data successfully")
			},
			
			failure: { (operation, error) -> Void in
				self.showMessage("Please download the API seed so that you can call it.")
		})
		operation.start()
	}
	
	private func showMessage(message: String) {
		let alert = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
		alert.show()
	}
	
	private func buildAPIRequest() -> NSURLRequest {
		let info = NSBundle.mainBundle().infoDictionary!
		let urlString = info["SampleAPIBaseURL"] as! String
		let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		let keychain = MyApplication.sharedInstance.keychain
		let token = keychain.stringForKey("id_token")!
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		return request
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