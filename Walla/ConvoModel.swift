//
//  ConvoModel.swift
//  Walla
//
//  Created by Timothy Choh on 6/26/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

struct ConvoModel {
    
    let myBasic = Basic()
	
	var convoID: String?
	var uniqueID: String
	var authorID: String
	var userID: String
	var timestamp: Double
	
	init(snapshot: FIRDataSnapshot){ // Note: you can print any of these values for debugging purposes
		convoID = snapshot.key
		uniqueID = snapshot.value["uniqueID"] as! String
		authorID = snapshot.value["authorID"] as! String
		userID = snapshot.value["userID"] as! String
		timestamp =  snapshot.value["timestamp"] as! Double
	}
	
	init(convoID: String, uniqueID: String, authorID: String, userID: String) {
		self.convoID = convoID
		self.uniqueID = uniqueID
		self.authorID = authorID
		self.userID = userID
		self.timestamp = self.myBasic.getTimestamp()
	}
}