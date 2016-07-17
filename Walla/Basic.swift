//
//  Basic.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

let rootPath = "https://thegenieapp.firebaseio.com"

class Basic {
	// rule: keep all explicit Firebase calls here.
	
	// Create a reference to a Firebase location
    // https://thegenieapp.firebaseio.com/

	let rootRef = Firebase(url: rootPath)
	let requestRef = Firebase(url: rootPath + "/Requests")
	let userRef = Firebase(url: rootPath + "/Users")
	let convoRef = Firebase(url: rootPath + "/Conversations")
	let messageRef = Firebase(url: rootPath + "/Messages")
    
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