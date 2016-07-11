//
//  UserBackend.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

var globalUid: String = "" 

class UserBackend {
	
	let myBasic = Basic()
    
	func logout() {
		myBasic.rootRef.unauth()
	}
	
	func updateUserData(key: String, value: AnyObject, userID: String) {
		let pair = [key:value]
		let pairRef = myBasic.userRef.childByAppendingPath(userID)
		pairRef.updateChildValues(pair)
	}
	
	func updateNotificationSetting(setting: String, value: Bool, userID: String) {
		let pair = [setting:value]
		let pairRef = myBasic.userRef.childByAppendingPath(userID)
		pairRef.updateChildValues(pair)
	}
	
	func updateUserDataWithChildPath(key: String, value: String, userID: String, path: String) {
		let pair = [key:value]
		let pairRef = myBasic.userRef.childByAppendingPath(userID).childByAppendingPath(path)
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
        defaults.setValue(uid, forKey: "localUid")
        defaults.synchronize()
    }
	
	func getUserID() -> String {
        print("womp user id")
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = self.myBasic.rootRef.authData {
            print("womp " + data.uid)
            return data.uid
        }
        else if let localUid = defaults.stringForKey("localUid") {
            print("womp local " + localUid)
            return localUid
        }
        else {
            print("womp global " + globalUid)
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
                    if let snapshot = snapshot {
                        if let out = snapshot.value[param]!! as? AnyObject {
                            completion(result: out)
                        }
                    }
                }
                
            })
    }
	
}