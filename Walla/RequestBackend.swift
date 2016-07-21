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
                    if let out = snapshot.value![key] as? String {
                        completion(result: out)
                    }
                }
            })
    }
    
    func contains(models: [RequestModel], snapshot: FIRDataSnapshot) -> Bool {
        for model in models {
            if model.postID == snapshot.key {
                return true
            }
        }
        return false
    }
    
    // true = valid, false = expired
    func checkSnapExpired(snap: FIRDataSnapshot) -> Bool {
        if let exp = snap.value!.objectForKey("expirationDate")?.doubleValue {
            return exp >= self.myBasic.getTimestamp()
        }
        return false
    }
    
    // true = valid tags, false = does not match tags
    func checkTags(snap: FIRDataSnapshot, tags: [String]) -> Bool {
        if tags.contains("All") || tags.contains("Time") {
            return true
        }

        var ret = true
        if let requestTags = snap.value!.objectForKey("tags") as? [String] {
            for tag in tags {
                if (!requestTags.contains(tag)) {
                    ret = false
                }
            }
        }
        return ret
    }
    
    func populateFilter() {
        let refToTry = self.myBasic.userRef.child(self.myUserBackend.getUserID())
        
        refToTry.observeEventType(.Value, withBlock: { snapshot in
            // Confirm that User has preset tags
            if snapshot.value!.objectForKey("tags") != nil {
                if let tagsToAppend = snapshot.value!.objectForKey("tags") as? [String] {
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
