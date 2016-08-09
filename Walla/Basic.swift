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
    
    let requestRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Requests")
    let userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Users")
    let convoRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Conversations")
    let messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Messages")
    
    func getTimestamp() -> Double {
        return NSDate().timeIntervalSince1970
    }
    
    func addUserSignedInListener() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("womp user is signed in!")
                print(user) 
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