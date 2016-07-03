//
//  ViewDetails.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

var myMessageTitle = ""

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
	
	@IBAction func goBack(sender: UIBarButtonItem)
	{
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func goToMessages(sender: UIButton)
	{
		myMessageTitle = requestModels[currentIndex].request
		let requestID = requestModels[currentIndex].postID!
		let authorID = requestModels[currentIndex].authorID
		let userID = myBasic.rootRef.authData.uid
		let convoHash = createConvoHash(requestID, authorID: authorID, userID: userID)
		let testRef = myBasic.convoRef.childByAppendingPath(convoHash)
		testRef.observeEventType(.Value, withBlock: { snapshot in
			if snapshot.value is NSNull {
				self.createSingleConvoRef(requestID, authorID: authorID, userID: userID)
			}
			else {
				self.convoID = convoHash
				//self.tabBarController?.tabBar.hidden = false
				//self.tabBarController?.selectedIndex = 3
				//ConvoViewController().startConvoFromWalla()
				//self.performSegueWithIdentifier("showMessage", sender: self)
                self.performSegueWithIdentifier("unwindToMessages", sender: self)
			}
		})
	}
	
	/*@IBAction func goToMessages(sender: AnyObject) {
	self.performSegueWithIdentifier("unwindToMenu", sender: self)
	}*/
	
	func createConvoHash(requestID: String, authorID: String, userID: String) -> String {
		let toHash = requestID + authorID + userID
		return String(toHash.hashValue)
	}
	
	// Should only be called by users other than the Author
	func createSingleConvoRef(requestID: String, authorID: String, userID: String) {
        
        print("womp creating single convo ref")
		
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
                self.performSegueWithIdentifier("unwindToMessages", sender: self)
			}
		})
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "unwindToMessages" {
            var index: Int = 0
            for convo in convoModels {
                if (convo.convoID == self.convoID) {
                    print("womp convo found with index " + String(index))
                    let  convoVC = segue.destinationViewController as! ConvoViewController
                    convoVC.selectIndex(index)
                    convoVC.womp()
                    break
                }
                index += 1
            }
		}
	}

}