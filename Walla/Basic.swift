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
	
    var rootRef: FIRDatabaseReference = FIRDatabase.database().reference()
    
    let requestRef: FIRDatabaseReference = rootRef.child("Requests")
    let userRef: FIRDatabaseReference = rootRef.child("Users")
    let convoRef: FIRDatabaseReference = rootRef.child("Conversations")
    let messageRef: FIRDatabaseReference = rootRef.child("Messages")
    
    func getTimestamp() -> Double {
        return NSDate().timeIntervalSince1970 
    }
    
    func addUserSignedInListener() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("womp user is signed in!")
            } else {
                print("womp no user signed in :/")
            }
        }
    }
	
	func checkLoggedIn() -> Bool {
        if let user = FIRAuth.auth()?.currentUser {
            print("womp user is signed in!")
        } else {
            print("womp no user signed in :/")
        }
        return FIRAuth.auth()?.currentUser != nil // true if logged in, false if not logged in
	}
}