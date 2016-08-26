//
//  ConvoBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/29/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

// Backend methods related to Conversations and Messages (based on RequestBackend.swift) 

import Foundation
import Firebase

class ConvoBackend {
    
    let myBasic = Basic()
    let myUserBackend = UserBackend()
    
    // Returns Conversation fields provided a key and ConvoID
    // Callback function needed in order to 'return' out of the Firebase void method
    func getConversationValue(convoID: String, key: String, completion: (result: String) -> Void) {
        
        self.myBasic.convoRef.queryOrderedByChild(convoID)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == convoID {
                    if let out = snapshot.value![key] as? String {
                        completion(result: out)
                    }
                }
            })
    }
    
    // Check if ConvoModels array contains a given Convo Firebase snapshot
    func contains(models: [ConvoModel], snapshot: FIRDataSnapshot) -> Bool {
        for model in models {
            if model.convoID == snapshot.key {
                return true
            }
        }
        return false
    }
    
    // Refresh array of ConvoModels (call this when switching to/from Convo screen, swipe down from top of Convo screen to refresh, etc.)
    func reloadConvoModels() {
        convoModels.removeAll()
        let myID = self.myUserBackend.getUserID()
        let ref = self.myBasic.convoRef
        
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            // Check 1) Non-null 2) Not a duplicate and 3) Relevant to User
            if (!(snapshot.value is NSNull) && !self.contains(convoModels, snapshot:snapshot) && self.checkSnapIncludesUid(snapshot, uid: myID) ) {
                convoModels.insert(ConvoModel(snapshot:snapshot), atIndex:0)
            }
            
        })
    }
    
    // Return true = valid, false = not valid
    func checkSnapIncludesUid(snap: FIRDataSnapshot, uid: String) -> Bool {
        if let authorID = snap.value?.objectForKey("authorID") as? String {
            if let userID = snap.value?.objectForKey("userID") as? String {
                return authorID == uid || userID == uid
            }
        }
        return false
    }
 
    // Returns the other person's UserID (NOT displayName... do that later)
    // Used to determine if user is author or recipient of a message 
    func printNotMe(model: ConvoModel, userID: String) -> String {
        let idOne: String = model.authorID
        let idTwo: String = model.userID
        
        return (idOne == userID) ? idTwo : idOne
    }
    
}
