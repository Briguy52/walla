//
//  RequestBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/28/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

// Backend methods related to the creation, editing, viewing, and responding to Requests (Posts)

import Foundation
import Firebase

class RequestBackend {
    
    let myBasic = Basic()
    let myUserBackend = UserBackend()
    
    // Returns a field within a Request (sender, title, etc.) provided the Request unique ID 
    // Callback function needed in order to 'return' out of the Firebase void method
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
    
    // Define a contains() method to check if an array of Requests contains a desired Request Firebase snapshot
    func contains(models: [RequestModel], snapshot: FIRDataSnapshot) -> Bool {
        for model in models {
            if model.postID == snapshot.key {
                return true
            }
        }
        return false
    }
    
    // Return true = valid, false = expired
    func checkSnapExpired(snap: FIRDataSnapshot) -> Bool {
        if let exp = snap.value!.objectForKey("expirationDate")?.doubleValue {
            return exp >= self.myBasic.getTimestamp()
        }
        return false
    }
    
    // Return true = valid tags, false = does not match tags
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
    
    // Count attendees by returning size of attendee list
    func countAttendees(postID: String, completion: (result: Int) -> Void) {
        myBasic.requestRef.queryOrderedByChild(postID)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == postID {
                    // If attendees list exists and I'm not on it, add myself and push!
                    if var out = snapshot.value!["attendees"] as? [String] {
                        completion(result: out.count + 1)
                    }
                        // If no attendees yet, count only the creator (1)
                    else {
                        completion(result: 1)
                    }
                }
            })
    }
    
    // Append user to the attendee list if it exists, else create new list with user as only attendee (ie user was the creator)
    func addSelfToAttendees(postID: String, myID: String) {
        myBasic.requestRef.queryOrderedByChild(postID)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.key == postID {
                    // If attendees list exists and I'm not on it, add myself and push!
                    if var out = snapshot.value!["attendees"] as? [String] {
                        if !out.contains(myID) {
                            out.append(myID)
                            self.myBasic.requestRef.child(postID).child("attendees").setValue(out)
                        }
                    }
                        // If no attendees yet, create new list and push!
                    else {
                        self.myBasic.requestRef.child(postID).child("attendees").setValue([myID])
                    }
                }
            })

    }
    
    // Take the user's tags (from Firebase) and filter out all results that do not match 
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
