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
    
    func getRequestTitle(uniqueID: String)
    
    func getRequestValue(uniqueID: String, key: String, completion: (result: String) -> Void) {
        
        
        
        let ref = myBasic.rootRef.childByAppendingPath(self.userPath)
        ref.queryOrderedByChild(key).queryLimitedToFirst(1)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let snapshot = snapshot {
                    if let out = snapshot.value[param] as? String {
                        completion(result: out)
                    }
                }
            })
        
    }

    
}
