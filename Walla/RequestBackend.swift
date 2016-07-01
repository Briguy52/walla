//
//  RequestBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/28/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

class RequestBackend {
    
    let myBasic = Basic()
    
    // TODO: get this to return AnyObject
    func getRequestValue(uniqueID: String, key: String, completion: (result: String) -> Void) {
        
        myBasic.requestRef.queryOrderedByChild(uniqueID).queryLimitedToFirst(1)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let snapshot = snapshot {
                    if let out = snapshot.value[key] as? String {
                        completion(result: out)
                    }
                }
            })
    }
    
    func customContains(models: [RequestModel], snapshot: FDataSnapshot) -> Bool {
        if let snapID = snapshot.key {
            for model in models {
                if model.postID == snapID {
                    return true
                }
            }
        }
        return false
    }
}
