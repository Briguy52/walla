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
    
    // New
    func getUserProfileInfo() {
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
        } else {
            // No user is signed in.
        }
    }
    
    // New
    func getUserProviderData() {
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                let providerID = profile.providerID
                let uid = profile.uid;  // Provider-specific UID
                let name = profile.displayName
                let email = profile.email
                let photoURL = profile.photoURL
            }
        } else {
            // No user is signed in.
        }
    }
    
    func nativeLogin(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if (error != nil) {
                print("womp successfully logged in user ")
                print(user) 
            }
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