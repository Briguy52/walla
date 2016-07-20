//
//  ConvoBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/29/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

class ConvoBackend {
    
    let myBasic = Basic()
    let myUserBackend = UserBackend()
    var disposeBag = DisposeBag()
    
    func getConversationValue(convoID: String, key: String, completion: (result: String) -> Void) {
        
        self.myBasic.convoRef.queryOrderedByChild(convoID)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == convoID {
                    if let snapshot = snapshot {
                        if let out = snapshot.value[key] as? String {
                            completion(result: out)
                        }
                    }
                }
            })
    }
    
    func contains(models: [ConvoModel], snapshot: FDataSnapshot) -> Bool {
        if let snapID = snapshot.key {
            for model in models {
                if model.convoID == snapID {
                    return true
                }
            }
        }
        return false
    }
    
    // Copied from MessagingVC, remainder of code to use is there
    func reloadConvoModels() {
        convoModels.removeAll()
        let myID = self.myUserBackend.getUserID()
        let ref = self.myBasic.convoRef
        
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            // Check 1) Non-null 2) Not a duplicate and 3) Relevant to User
            if (!(snapshot.value is NSNull) && !self.contains(convoModels, snapshot:snapshot) && (snapshot.value.objectForKey("authorID") as? String == myID || snapshot.value.objectForKey("userID") as? String == myID) ) {
                convoModels.insert(ConvoModel(snapshot:snapshot), atIndex:0)
            }
            
        })
    }

    
    // Returns the other person's UserID (NOT displayName... do that later)
    func printNotMe(model: ConvoModel, userID: String) -> String {
        let idOne: String = model.authorID
        let idTwo: String = model.userID
        
        return (idOne == userID) ? idTwo : idOne
    }
    
}
