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
	
	// Create a reference to a Firebase location
	let rootPath = "https://thegenieapp.firebaseio.com/dev/"
	let rootRef = Firebase(url: "https://thegenieapp.firebaseio.com/dev/")
	let requestRef = Firebase(url:"https://thegenieapp.firebaseio.com/dev/Requests")
	let userRef = Firebase(url:"https://thegenieapp.firebaseio.com/dev/Users")
	let convoRef = Firebase(url:"https://thegenieapp.firebaseio.com/dev/Conversations")
	let messageRef = Firebase(url:"https://thegenieapp.firebaseio.com/dev/Messages")
	
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