//
//  UserBackend.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

// Resource I'm using: https://firebase.google.com/docs/auth/ios/manage-users

// Replace childByAppendingPath() with just child()
// Replace self.myBasic.rootRef.authData with FIRAuth.auth()?.currentUser

import Foundation
import Firebase

var globalUid: String = ""
var senderDict: [String: String] = [String:String]()

class UserBackend {
	
	let myBasic = Basic()
    static let localUserKey: String = "localUid"
    
	func logout() {
		try! FIRAuth.auth()!.signOut()
	}
    
    // Temporary method with all the hardcoded auth calls
    func hardCodedLogin() {
        let tempEmail = "brian@womp.com"
        let tempPass = "wompwomp"
        
        // Uncomment this to CREATE a new user
//        self.nativeCreateUser(tempEmail, password: tempPass)
        
        // This line logs in an EXISTING user
        self.nativeLogin(tempEmail, password: tempPass)
        
        safeToLoadID = true
        
    }
    
    func nativeCreateUser(email: String, password: String, displayName: String, name: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            print("womp create user callback")
            print(error)
            print(user)
            
            if (user != nil) {
                // Post some default user data
                if let data = user {
                    
//                    var displayName = "womp"
//                    var name = "womp"
//                    var profilePicUrl = "https://metrouk2.files.wordpress.com/2009/12/article-1260439489005-07877bac000005dc-595563_636x932.jpg"
                    
//                    var displayName = "brian"
//                    var name = "brian"
                    var profilePicUrl = "http://media.npr.org/assets/img/2016/03/29/ap_090911089838_sq-3271237f28995f6530d9634ff27228cae88e3440-s900-c85.jpg"
                    
                    self.updateUserData("displayName", value: displayName, userID: data.uid)
                    self.updateUserData("name", value: name, userID: data.uid)
                    self.updateUserData("profilePicUrl", value: profilePicUrl, userID: data.uid)
                    self.updateUserData("phoneNumber", value: "12345678", userID: data.uid)
                    self.updateUserData("latitude", value: 36.0014, userID: data.uid)
                    self.updateUserData("longitude", value: 78.9382, userID: data.uid)
                    self.updateUserData("karma", value: 0, userID: data.uid)
                    
                    self.updateNotificationSetting("pushNotifications", value: true, userID: data.uid)
                    self.updateNotificationSetting("messageNotification", value: true, userID: data.uid)
                    self.updateNotificationSetting("helpMeResponseNotifcation", value: true, userID: data.uid)
                    self.updateNotificationSetting("newRequestNotification", value: true, userID: data.uid)
                    self.updateNotificationSetting("requestResolvedNotification", value: true, userID: data.uid)
                }
                

            }
        }
    }
    
    func nativeLogin(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            print("womp login user callback")
            print(error)
            print(user) 
        }
    }
	
	func updateUserData(key: String, value: AnyObject, userID: String) {
		let pair = [key:value]
        let pairRef = myBasic.userRef.child(userID)
		pairRef.updateChildValues(pair)
	}
	
	func updateNotificationSetting(setting: String, value: Bool, userID: String) {
		let pair = [setting:value]
        let pairRef = myBasic.userRef.child(userID)
		pairRef.updateChildValues(pair)
	}
	
	func updateUserDataWithChildPath(key: String, value: String, userID: String, path: String) {
		let pair = [key:value]
        let pairRef = myBasic.userRef.child(userID).child(path)
		pairRef.updateChildValues(pair)
	}
	
	func updateUserConversations(convoID: String, userID: String) {
		self.updateUserDataWithChildPath(convoID, value: convoID, userID: userID, path: "Conversations")
	}
	
	func updateUserPosts(postID: String, userID: String) {
		self.updateUserDataWithChildPath(postID, value: postID, userID: userID, path: "Requests")
	}
    
    func saveUidLocally(uid: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(uid, forKey: UserBackend.localUserKey)
        defaults.synchronize()
    }
	
	func getUserID() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = FIRAuth.auth()?.currentUser {
            print("User ID retrieved via Firebase call")
            return data.uid
        }
        else if let localUid = defaults.stringForKey(UserBackend.localUserKey) {
            print("User ID retrieved locally")
            return localUid
        }
        else {
            print("User ID retrieved via global var")
            return globalUid
        }
	}
	
	// Example usage of getUserName()
	
	//    let ub = UserBackend()
	//    print(ub.getUserID())
	//    ub.getUserName(ub.getUserID()) {
	//    (result: String) in
	//    print("got back: \(result)")
	//    }
	
	func getUserInfo(param: String, userID: String, completion: (result: AnyObject) -> Void) {
        let key = userID
        let ref = myBasic.userRef
        ref.queryOrderedByChild(key)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == userID {
                    if let out = snapshot.value![param]!! as? AnyObject {
                        completion(result: out)
                    }
                }
            })
    }
    
    func reloadSenderDict() {
        let ref = self.myBasic.userRef
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            senderDict[snapshot.key] = snapshot.value!["displayName"] as? String            
            })
        print("sender dict")
        print(senderDict)
    }
    
    func getSenderName(sender: String) -> String {
        if senderDict.keys.contains(sender) {
            return senderDict[sender]!
        }
        else {
            return "Anonymous Wallaby"
        }
    }

	
}