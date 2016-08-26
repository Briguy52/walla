//
//  Basic.swift
//  Walla
//
//  Created by Brian Lin on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

class Basic {
	
    var rootRef: FIRDatabaseReference = FIRDatabase.database().reference()
    
    let requestRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Requests")
    let userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Users")
    let convoRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Conversations")
    let messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Messages")
    
    // Use for all calls for current time
    func getTimestamp() -> Double {
        return NSDate().timeIntervalSince1970
    }
    
    // Listener for debugging auth
    func addUserSignedInListener() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("User is signed in!")
                print(user) 
            } else {
                print("No user signed in :/")
            }
        }
    }
	
    // Method for determining auth status
	func checkLoggedIn() -> Bool {
        if let user = FIRAuth.auth()?.currentUser {
            print("User is signed in!")
        } else {
            print("No user signed in :/")
        }
        return FIRAuth.auth()?.currentUser != nil // true if logged in, false if not logged in
	}
}