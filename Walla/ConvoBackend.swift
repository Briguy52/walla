//
//  ConvoBackend.swift
//  Walla
//
//  Created by Brian Lin on 6/29/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import RxSwift
import FirebaseRxSwiftExtensions

class ConvoBackend {
    
    let myBasic = Basic()
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
        let myID = myBasic.rootRef.authData.uid
        myBasic.convoRef.rx_observe(FEventType.ChildAdded)
            .filter { snapshot in
                // Note: can also add filters for tags, location, etc.
                return !(snapshot.value is NSNull)
            }
            .filter { snapshot in
                return !self.contains(convoModels, snapshot: snapshot) // avoids showing duplicate Convos on initial load
            }
            .filter { snapshot in
                // Only return Snapshots with authorID or userID == user's ID
                return (snapshot.value.objectForKey("authorID") as? String == myID || snapshot.value.objectForKey("userID") as? String == myID)
            }
            .map {snapshot in
                return ConvoModel(snapshot: snapshot)
            }
            .subscribeNext({ (convoModel: ConvoModel) -> Void in
                convoModels.insert(convoModel, atIndex: 0);
            })
            .addDisposableTo(self.disposeBag)
    }
    
    // Returns the other person's UserID (NOT displayName... do that later)
    func printNotMe(model: ConvoModel, userID: String) -> String {
        let idOne: String = model.authorID
        let idTwo: String = model.userID
        
        return (idOne == userID) ? idTwo : idOne
    }
    
}
