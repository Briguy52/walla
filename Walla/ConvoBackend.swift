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
    
    
}
