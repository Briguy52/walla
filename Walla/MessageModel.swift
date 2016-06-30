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
	var sender: String // userID of sender, via UserBackend
	var text: String // contents of message, via MessageViewController
	var recipient: String // userID of recipient, via UserBackend + Firebase lookup
	var timestamp: Double
	
	init(snapshot: FDataSnapshot){
		messageId = snapshot.key
		text = snapshot.value["text"] as! String
		sender = snapshot.value["sender"] as! String
		recipient = snapshot.value["recipient"] as! String
		timestamp =  snapshot.value["timestamp"] as! Double
	}
	
	init(text: String, sender: String, recipient: String) {
		self.text = text
		self.sender = sender
		self.recipient = recipient
		self.timestamp = NSDate().timeIntervalSince1970 * 1000.0
	}
}