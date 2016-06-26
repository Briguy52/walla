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
	
	var convoID: String?
	var title: String
	var authorID: String
	var userID: String
	var timestamp: Double
	
	init(snapshot: FDataSnapshot){ // Note: you can print any of these values for debugging purposes
		convoID = snapshot.key
		title = snapshot.value["title"] as! String
		authorID = snapshot.value["authorID"] as! String
		userID = snapshot.value["userID"] as! String
		timestamp =  snapshot.value["timestamp"] as! Double
	}
	
	init(convoID: String, title: String, authorID: String, userID: String) {
		self.convoID = convoID
		self.title = title
		self.authorID = authorID
		self.userID = userID
		self.timestamp = NSDate().timeIntervalSince1970 * 1000.0
	}
}