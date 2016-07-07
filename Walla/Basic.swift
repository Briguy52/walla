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
    // https://thegenieapp.firebaseio.com/
	let rootPath = "https://thegenieapp.firebaseio.com/"
	let rootRef = Firebase(url: "https://thegenieapp.firebaseio.com/")
	let requestRef = Firebase(url:"https://thegenieapp.firebaseio.com/Requests")
	let userRef = Firebase(url:"https://thegenieapp.firebaseio.com/Users")
	let convoRef = Firebase(url:"https://thegenieapp.firebaseio.com/Conversations")
	let messageRef = Firebase(url:"https://thegenieapp.firebaseio.com/Messages")
	
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