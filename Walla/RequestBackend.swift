//
//  RequestBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/28/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation

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

    
}
