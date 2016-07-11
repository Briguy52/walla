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
    let myUserBackend = UserBackend()
    
    // TODO: get this to return AnyObject
    func getRequestValue(uniqueID: String, key: String, completion: (result: String) -> Void) {
        
        myBasic.requestRef.queryOrderedByChild(uniqueID)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == uniqueID {
                    if let snapshot = snapshot {
                        if let out = snapshot.value[key] as? String {
                            completion(result: out)
                        }
                    }
                }
            })
    }
    
    func contains(models: [RequestModel], snapshot: FDataSnapshot) -> Bool {
        if let snapID = snapshot.key {
            for model in models {
                if model.postID == snapID {
                    return true
                }
            }
        }
        return false
    }
    
    func populateFilter() {
        let refToTry = self.myBasic.userRef.childByAppendingPath(self.myUserBackend.getUserID())
        
        refToTry.observeEventType(.Value, withBlock: { snapshot in
            // Confirm that User has preset tags
            if snapshot.value.objectForKey("tags") != nil {
                if let tagsToAppend = snapshot.value.objectForKey("tags") as? [String] {
                    for index in 0..<tagsToAppend.count {
                        if !filterTags.contains(tagsToAppend[index]) {
                            filterTags.append(tagsToAppend[index])
                        }
                    }
                }
            }
        })
    }
}
