//
//  UserBackend.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

class UserBackend {
	
	let myBasic = Basic()
	let userPath = "users"
	
	func logout() {
		myBasic.rootRef.unauth()
	}
	
	func updateUserData(key: String, value: AnyObject, userID: String) {
		let pair = [key:value]
		let pairRef = myBasic.userRef.childByAppendingPath(userID)
		pairRef.updateChildValues(pair)
	}
	
		// TODO: test type cast
	func updateKarma(karma: Int, userID: String) {
		self.updateUserData("karma", value: String(karma), userID: userID)
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
	
	func getUserID() -> String {
		return self.myBasic.rootRef.authData.uid
	}
	
	// Example usage of getUserName()
	
	//    let ub = UserBackend()
	//    print(ub.getUserID())
	//    ub.getUserName(ub.getUserID()) {
	//    (result: String) in
	//    print("got back: \(result)")
	//    }
	
	func getUserInfo(param: String, userID: String, completion: (result: String) -> Void) {
		let key = userID
		let ref = myBasic.rootRef.childByAppendingPath(self.userPath)
		ref.queryOrderedByChild(key).queryLimitedToFirst(1)
			.observeEventType(.ChildAdded, withBlock: { snapshot in
				if let snapshot = snapshot {
                    print(snapshot)
					if let out = snapshot.value[param] as? String {
						completion(result: out)
					}
				}
			})
	}
    
    func getStuff(param: String, userID: String, completion: (result: AnyObject) -> Void) {
        let key = userID
        let ref = myBasic.rootRef.childByAppendingPath(self.userPath)
        ref.queryOrderedByChild(key).queryLimitedToFirst(1)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let snapshot = snapshot {
                    print(snapshot)
                    if let out = snapshot.value[param] {
                        completion(result: out!)
                    }
                }
            })
    }
	
	func getNumPosts(userID: String, completion: (result: String) -> Void) {
		let key = userID
		let ref = myBasic.rootRef.childByAppendingPath(self.userPath)
		ref.queryOrderedByChild(key).queryLimitedToFirst(1)
			.observeEventType(.ChildAdded, withBlock: { snapshot in
				if let out = snapshot.value.valueForKey("Requests") {
					completion(result: String(out.count))
				}
			})
	}
	
}