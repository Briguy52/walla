//
//  UserBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

// Resource I'm using for migration from old Firebase to Google Firebase: https://firebase.google.com/docs/auth/ios/manage-users

// Note: Replace childByAppendingPath() with just child()
// Note: Replace self.myBasic.rootRef.authData with FIRAuth.auth()?.currentUser

import Foundation
import Firebase

var globalUid: String = "" // used for fast retrieval of user's user ID
var senderDict: [String: String] = [String:String]() // 'cache' user IDs here for fast retrieval (ie don't make Firebase calls for IDs already retrieved)

class UserBackend {
	
	let myBasic = Basic()
    static let localUserKey: String = "localUid"
    
	func logout() {
		try! FIRAuth.auth()!.signOut()
	}
    
    // Use Firebase's built-in methods to create a new user
    func nativeCreateUser(email: String, password: String, displayName: String, name: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            
            if (user != nil) {
                // Post some default user data
                if let data = user {
                
                    var profilePicUrl = "http://media.npr.org/assets/img/2016/03/29/ap_090911089838_sq-3271237f28995f6530d9634ff27228cae88e3440-s900-c85.jpg"
                    
                    self.updateUserData("email", value: email, userID: data.uid)
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
    
    // Use Firebase's native methods to login a user
    func nativeLogin(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            print("womp login user callback")
            print(error)
            print(user)
        }
    }
	
    // Helper method to update user data
	func updateUserData(key: String, value: AnyObject, userID: String) {
		let pair = [key:value]
        let pairRef = myBasic.userRef.child(userID)
		pairRef.updateChildValues(pair)
	}
	
    // Helper method to update user Notification settings
	func updateNotificationSetting(setting: String, value: Bool, userID: String) {
		let pair = [setting:value]
        let pairRef = myBasic.userRef.child(userID)
		pairRef.updateChildValues(pair)
	}
	
    // Helper methopd to update user data at specific child path
	func updateUserDataWithChildPath(key: String, value: String, userID: String, path: String) {
		let pair = [key:value]
        let pairRef = myBasic.userRef.child(userID).child(path)
		pairRef.updateChildValues(pair)
	}
	
    // Method to update user's active conversations
	func updateUserConversations(convoID: String, userID: String) {
		self.updateUserDataWithChildPath(convoID, value: convoID, userID: userID, path: "Conversations")
	}
	
    // Method to update user's active posts
	func updateUserPosts(postID: String, userID: String) {
		self.updateUserDataWithChildPath(postID, value: postID, userID: userID, path: "Requests")
	}
    
    // Method to save user ID locally (not pushed to Firebase)
    func saveUidLocally(uid: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(uid, forKey: UserBackend.localUserKey)
        defaults.synchronize()
    }
	
    // Method to retrieve user ID from possible sources (Firebase, local defaults, or local global variable) 
    // Corrects for async. issues due to Firebase calls
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
	
	// Example usage of callback method
	
	//    let ub = UserBackend()
	//    print(ub.getUserID())
	//    ub.getUserName(ub.getUserID()) {
	//    (result: String) in
	//    print("got back: \(result)")
	//    }
	
    // Callback method for getting user info (b/c all Firebase query methods are void)
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
    
    // Update local sender dict with retrieved user ID
    func reloadSenderDict() {
        let ref = self.myBasic.userRef
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            senderDict[snapshot.key] = snapshot.value!["displayName"] as? String            
            })
        print("sender dict reloaded")
        print(senderDict)
    }
    
    // Retrieve username from sender dict, if no match found, return placeholder 
    func getSenderName(sender: String) -> String {
        if senderDict.keys.contains(sender) {
            return senderDict[sender]!
        }
        else {
            return "Anonymous Wallaby"
        }
    }

	
}