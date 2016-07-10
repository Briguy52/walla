//
//  AuthViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import JWTDecode
import MBProgressHUD
import Lock
import Alamofire
import Firebase

class AuthViewController: UIViewController {
	
	let client_id = "NiZctA0id6Bd5IgTLcEoYai116RirhUw"
	let myUserBackend = UserBackend()
	let myBasic = Basic()
    
    var hasShownAuthScreen: Bool = false
    
    func customizeTheme() {
        let myTheme = A0Theme()
        
        //Customize your theme
        myTheme.registerImageWithName("background", bundle: NSBundle.mainBundle(), forKey: "A0ThemeScreenBackgroundImageName")
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeTextFieldPlaceholderTextColor")
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeTextFieldTextColor")
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeTextFieldIconColor")
        
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeCredentialBoxBorderColor")
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeCredentialBoxSeparatorColor")
        
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeSecondaryButtonBackgroundColor")
        myTheme.registerColor(UIColor.blackColor(), forKey: "A0ThemeSecondaryButtonTextColor")
        
        myTheme.registerImageWithName("AppIcon_60", bundle: NSBundle.mainBundle(), forKey: "A0ThemeIconImageName")
        
        A0Theme.sharedInstance().registerTheme(myTheme)
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.customizeTheme()
        
		let keychain = MyApplication.sharedInstance.keychain
		if let idToken = keychain.stringForKey("id_token"), let jwt = try? JWTDecode.decode(idToken) {
			if jwt.expired, let refreshToken = keychain.stringForKey("refresh_token") {
				MBProgressHUD.showHUDAddedTo(self.view, animated: true)
				let success = {(token:A0Token!) -> () in
					keychain.setString(token.idToken, forKey: "id_token")
					MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.performSafeShowProfile()
				}
				let failure = {(error:NSError!) -> () in
					keychain.clearAll()
					MBProgressHUD.hideHUDForView(self.view, animated: true)
				}
				let client = MyApplication.sharedInstance.lock.apiClient()
				client.fetchNewIdTokenWithRefreshToken(refreshToken, parameters: nil, success: success, failure: failure)
			}
		}
	}
	
	// TODO: change to viewDidAppear() if you want to show sign-in immediately
	override func viewDidAppear(animated: Bool) {
		let lock = MyApplication.sharedInstance.lock
		let authController = lock.newLockViewController()
		authController.closable = true
		authController.onAuthenticationBlock = { (profile, token) -> () in
			switch (profile, token) {
			case (.Some(let profile), .Some(let token)):
				self.auth0Delegation(token.idToken)
				let keychain = MyApplication.sharedInstance.keychain
				keychain.setString(token.idToken, forKey: "id_token")
				if let refreshToken = token.refreshToken {
					keychain.setString(refreshToken, forKey: "refresh_token")
				}
				keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(profile), forKey: "profile")
				self.dismissViewControllerAnimated(true, completion: nil)
				self.performSafeShowProfile()
			default:
				print("User signed up without logging in")
			}
		}
        if (!self.hasUserAuthenticated()) {
            self.presentViewController(authController, animated: true, completion: nil)
        }
        else {
            self.performSafeShowProfile()
        }
	}
	
	// Source: https://auth0.com/docs/auth-api#!#post--delegation, https://auth0.com/authenticate/ios-swift/firebase
	// Note: this method has been tested and works!
	func auth0Delegation(idToken: String) {
		let grant_type = "urn:ietf:params:oauth:grant-type:jwt-bearer"
		let id_token = idToken
		let scope = "open_id"
		let api_type = "firebase"
		let myParameters = [
			"client_id": self.client_id,
			"grant_type": grant_type,
			"id_token": id_token,
			"scope": scope,
			"api_type": api_type]
		Alamofire.request(.POST, "https://genieapp.auth0.com/delegation", parameters: myParameters, encoding: .JSON)
			.responseJSON { response in
				if let myResponse = response.result.value {
					let firebaseToken = "\(myResponse["id_token"]!!)"
					self.authWithFirebaseToken(firebaseToken)
				}
		}
	}
    
    func performSafeShowProfile() {
        if (self.hasUserAuthenticated()) {
			print(self.myBasic.rootRef.authData)
            performSegueWithIdentifier("showProfile", sender: self)
        }
    }
	
    func hasUserAuthenticated() -> Bool {
        return self.myBasic.rootRef.authData != nil
    }
	
	// Source: https://www.firebase.com/docs/web/guide/login/custom.html (Authenticating Clients section)
	// Note: call this method from auth0Delegation
	func authWithFirebaseToken(firebaseToken: String) {
		let ref = myBasic.rootRef
		ref.authWithCustomToken(firebaseToken, withCompletionBlock: { error, authData in
			if error != nil {
				print("Login failed! \(error)")
			} else {
				print("Auth with Firebase Token")
				self.myUserBackend.updateUserData("provider", value: authData.provider, userID: authData.uid)
                self.performSafeShowProfile()
			}
		})
	}
}