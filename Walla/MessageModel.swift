//
//  MessageModel.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

struct MessageModel {
	var messageId: String? // unique message ID, randomly generated and untracked
	var name: String // display name of sender, via ???
	var sender: String // userID of sender, via UserBackend
	var body: String // contents of message, via MessageViewController
	var recipient: String // userID of recipient, via UserBackend + Firebase lookup
	var timestamp: Double
	
	init(snapshot: FDataSnapshot){
		messageId = snapshot.key
		name = snapshot.value["name"] as! String
		body = snapshot.value["body"] as! String
		sender = snapshot.value["sender"] as! String
		recipient = snapshot.value["recipient"] as! String
		timestamp =  snapshot.value["timestamp"] as! Double
	}
	
	init(name: String, body: String, sender: String, recipient: String) {
		self.name = name
		self.body = body
		self.sender = sender
		self.recipient = recipient
		self.timestamp = NSDate().timeIntervalSince1970 * 1000.0
	}
}