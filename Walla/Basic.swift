//
//  Basic.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

class Basic {
	// rule: keep all explicit Firebase calls here.
	
    var rootRef = FIRDatabase.database().reference()
    
	let requestRef = rootRef.child("Requests")
	let userRef = rootRef.child("Users")
	let convoRef = rootRef.child("Conversations")
	let messageRef = rootRef.child("Messages")
    
    func getTimestamp() -> Double {
        return NSDate().timeIntervalSince1970 
    }
	
	func checkLoggedIn() -> Bool {
		if rootRef.authData != nil {
			print(rootRef.authData)
			return true
		} else {
			print("No users signed in")
			return false
		}
	}
}