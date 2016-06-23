//
//  RequestModel.swift
//
//
//  Created by Brian Lin on 3/22/16.
//  Based on: https://github.com/mbalex99/flamingpants/blob/master/FlamingPants/MessageModel.swift
//

import Foundation
import Firebase

struct RequestModel {
	
	var postID: String? // unique post ID, randomly generated and untracked
	var title: String
	var content: String
	var authorID: String
	var latitude: String
	var longitude: String
	var urgency: String
	var tags: [String]
	var timestamp: Double // time the Request was created
	var expirationDate: Double // time the Request becomes invalidated (calculated OUTSIDE of this Model)
	
	init(snapshot: FDataSnapshot){ // Note: you can print any of these values for debugging purposes
		postID = snapshot.key
		title = snapshot.value["title"] as! String
		content = snapshot.value["content"] as! String
		authorID = snapshot.value["authorID"] as! String
		latitude = snapshot.value["latitude"] as! String
		longitude = snapshot.value["longitude"] as! String
		urgency = snapshot.value["urgency"] as! String
		tags = snapshot.value["tags"] as! [String]
		timestamp =  snapshot.value["timestamp"] as! Double
		expirationDate = snapshot.value["expirationDate"] as! Double
	}
	
	init(title: String, content: String, authorID: String, latitude: String, longitude: String, urgency: String, tags: [String], expirationDate: Double) {
		self.title = title
		self.content = content
		self.authorID = authorID
		self.latitude = latitude
		self.longitude = longitude
		self.urgency = urgency
		self.tags = tags
		self.timestamp = NSDate().timeIntervalSince1970
		self.expirationDate = expirationDate
	}
}