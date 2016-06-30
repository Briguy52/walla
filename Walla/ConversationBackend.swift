//
//  ConversationBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/29/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation

class ConversationBackend {
    
    let myBasic = Basic()
    
    func getConversationValue(convoID: String, key: String, completion: (result: String) -> Void) {
        
        self.myBasic.convoRef.queryOrderedByChild(convoID).queryLimitedToFirst(1)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let snapshot = snapshot {
                    if let out = snapshot.value[key] as? String {
                        completion(result: out)
                    }
                }
            })
    }
    
    
}
