//
//  RequestModel.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import Firebase

struct RequestModel {
	
    var myBasic = Basic()
    
	var postID: String? // unique post ID, randomly generated and untracked
	var request: String
	var additionalDetails: String
	var authorID: String
	var latitude: Double
	var longitude: Double
	var location: String
    var resolved: Bool
    var visible: Bool
	var tags: [String]
	var timestamp: Double // time the Request was created
	var expirationDate: Double // time the Request becomes invalidated (calculated OUTSIDE of this Model)
	
	init(snapshot: FIRDataSnapshot){ // Note: you can print any of these values for debugging purposes
		postID = snapshot.key
		request = snapshot.value["request"] as! String
		additionalDetails = snapshot.value["additionalDetails"] as! String
		authorID = snapshot.value["authorID"] as! String
		latitude = snapshot.value["latitude"] as! Double
		longitude = snapshot.value["longitude"] as! Double
		location = snapshot.value["location"] as! String
        resolved = snapshot.value["resolved"] as! Bool
        visible = snapshot.value["visible"] as! Bool
		tags = snapshot.value["tags"] as! [String]
		timestamp =  snapshot.value["timestamp"] as! Double
		expirationDate = snapshot.value["expirationDate"] as! Double
	}
	
    init(request: String, additionalDetails: String, authorID: String, latitude: Double, longitude: Double, location: String, resolved: Bool, visible: Bool, tags: [String], expirationDate: Double) {
		self.request = request
		self.additionalDetails = additionalDetails
		self.authorID = authorID
		self.latitude = latitude
		self.longitude = longitude
		self.location = location
        self.resolved = resolved
        self.visible = visible
		self.tags = tags
		self.timestamp = self.myBasic.getTimestamp()
		self.expirationDate = expirationDate
	}
}