// HomeViewController.swift
//
// Copyright (c) 2014 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// TODO: add corresponding UI/Storyboard elements to go with this ViewController

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keychain = MyApplication.sharedInstance.keychain
        if let idToken = keychain.stringForKey("id_token"), let jwt = try? JWTDecode.decode(idToken) {
            if jwt.expired, let refreshToken = keychain.stringForKey("refresh_token") {
                
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let success = {(token:A0Token!) -> () in
                    keychain.setString(token.idToken, forKey: "id_token")
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.performSegueWithIdentifier("showProfile", sender: self)
                }
                let failure = {(error:NSError!) -> () in
                    keychain.clearAll()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
                let client = MyApplication.sharedInstance.lock.apiClient()
                client.fetchNewIdTokenWithRefreshToken(refreshToken, parameters: nil, success: success, failure: failure)
            } else {
                self.performSegueWithIdentifier("showProfile", sender: self)
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
                self.performSegueWithIdentifier("showProfile", sender: self)
            default:
                print("User signed up without logging in")
            }
        }
        self.presentViewController(authController, animated: true, completion: nil)
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
    
    // Source: https://auth0.com/docs/auth-api#!#post--with_sms
    // Note: phone number must be in Twilio format (+12223334444)
    // Note: this method is UNTESTED (waiting on Twilio account from Yoon)
    func auth0SMS(phoneNumber: String) {
        let connection = "sms"
        let phone_number = phoneNumber
        let myParameters = [
            "client_id": self.client_id,
            "connection": connection,
            "phone_number": phone_number]
        Alamofire.request(.POST, "https://genieapp.auth0.com/passwordless/start", parameters: myParameters, encoding: .JSON)
            .responseJSON { response in
                if let myResponse = response.result.value {
                    print(myResponse)
                }
        }
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
                print(authData.uid)
                self.myUserBackend.updateUserData("token", value: authData.token, userID: authData.uid)
                self.myUserBackend.updateUserData("provider", value: authData.provider, userID: authData.uid)
            }
        })
    }    
}
