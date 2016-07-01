//
//  ViewDetails.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

class ViewDetails: UIViewController {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var additional: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var tags: UILabel!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	var currentTime = NSDate().timeIntervalSince1970
	var convoID:String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarController?.tabBar.hidden = true
		self.initRequestInfo()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.tabBarController?.tabBar.hidden = false
	}
	
	func initRequestInfo()
	{
		let requestModel = requestModels[currentIndex]
		//self.profile?.UIImage
		
		self.profile?.layer.borderWidth = 0.75
		self.profile?.layer.masksToBounds = false
		self.profile?.layer.borderColor = UIColor.blackColor().CGColor
		self.profile?.layer.cornerRadius = self.profile.frame.height / 4
		self.profile?.clipsToBounds = true
		
		self.message?.text = requestModel.request
		self.timestamp?.text = String(requestModel.timestamp)
        self.additional?.text = requestModel.additionalDetails
		self.location?.text = requestModel.location
		self.tags?.text = requestModel.tags.joinWithSeparator(" ")
	}
	
	@IBAction func startConvo(sender: AnyObject) {
        print("womp start convo")
        
		let requestID = requestModels[currentIndex].postID!
		let authorID = requestModels[currentIndex].authorID
		let userID = myBasic.rootRef.authData.uid
		let convoHash = createConvoHash(requestID, authorID: authorID, userID: userID)
		let testRef = myBasic.convoRef.childByAppendingPath(convoHash)
		testRef.observeEventType(.Value, withBlock: { snapshot in
			if snapshot.value is NSNull {
                print("womp null")
				self.createSingleConvoRef(requestID, authorID: authorID, userID: userID)
			}
			else {
                print("womp not null")
				self.convoID = convoHash
				self.performSegueWithIdentifier("showMessage", sender: self)
				self.tabBarController?.selectedIndex = 3
			}
		})
	}
	
	func createConvoHash(requestID: String, authorID: String, userID: String) -> String {
		let toHash = requestID + authorID + userID
		return String(toHash.hashValue)
	}
	
	// Should only be called by users other than the Author
	func createSingleConvoRef(requestID: String, authorID: String, userID: String) {
		
		let newConvo = [
			"uniqueID": requestID,
			"authorID": authorID,
			"userID": userID,
			"timestamp": currentTime
		]
		
		let convoHash = createConvoHash(requestID, authorID: authorID , userID: userID)
		
		// Create a new Conversation with the above information
		let newConvoRef = myBasic.convoRef.childByAppendingPath(convoHash)
		
		convoID = newConvoRef.key // make sure that convoID = convoHash
		newConvoRef.setValue(newConvo, withCompletionBlock: {
			(error:NSError?, ref:Firebase!) in
			if (error != nil) {
				print("Conversation data could not be saved.")
			} else {
				print("Conversation data saved successfully!")
				// Update user Firebase w/ new post ID
				self.myUserBackend.updateUserConversations(self.convoID, userID: authorID)
			}
		})
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showMessage" {
			let messagingVC = segue.destinationViewController as! MessageViewController
			messagingVC.convoID = self.convoID
		}
	}
}