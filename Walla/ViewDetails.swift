//
//  ViewDetails.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

var convoIDFromHome = ""

class ViewDetails: UIViewController {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var additional: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var tags: UILabel!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
    let myRequestBackend = RequestBackend()
	let myConvoBackend = ConvoBackend()
	var convoID:String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarController?.tabBar.hidden = true
		self.initRequestInfo()
		
		self.profile?.layer.borderWidth = 0.5
		self.profile?.layer.masksToBounds = false
		self.profile?.layer.borderColor = UIColor.blackColor().CGColor
		self.profile?.layer.cornerRadius = self.profile.frame.height / 2
		self.profile?.clipsToBounds = true
        
        self.myConvoBackend.reloadConvoModels()
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
        
        self.setImage()
        self.message?.text = requestModel.request
        self.timestamp?.text = parseDateFromTime(requestModel.timestamp)
        //		self.additional?.text = requestModel.additionalDetails
        self.myRequestBackend.countAttendees(requestModel.postID!) {
            (result: Int) in
            self.additional?.text = String(result) + " attendee(s)"
        }
        self.location?.text = requestModel.location
        self.tags?.text = requestModel.tags.joinWithSeparator(" ")
    }
	
	func parseDateFromTime(time: Double) -> String {
		let postedDate = NSDate(timeIntervalSince1970: time)
		
		let currentDate = NSDate()
		
		let hourMinute: NSCalendarUnit = [.Hour, .Minute]
		let difference = NSCalendar.currentCalendar().components(hourMinute, fromDate: postedDate, toDate: currentDate, options: [])
		var timeDifference: String = ""
		
		if difference.hour < 1
		{
			timeDifference = "\(difference.minute)m"
		}
		else
		{
			timeDifference = "\(difference.hour)h" + " " + "\(difference.minute)m"
		}
				
		return String("posted " + timeDifference + " ago")
	}
	
	func setImage()
	{
		self.myUserBackend.getUserInfo("profilePicUrl", userID: self.myUserBackend.getUserID())
		{
			(result: AnyObject) in
            if let url = NSURL(string: String(result)) {
                if let data = NSData(contentsOfURL: url){
                    self.profile.contentMode = UIViewContentMode.ScaleAspectFit
                    self.profile.image = UIImage(data: data)
                }
            }
		}
	}
	
	@IBAction func goBack(sender: UIBarButtonItem) {
		dismissViewControllerAnimated(true, completion: nil)
	}
    
    func buildRef() -> FIRDatabaseReference {
        let requestID = requestModels[currentIndex].postID!
        let authorID = requestModels[currentIndex].authorID
        let userID = self.myUserBackend.getUserID()
        let convoHash = createConvoHash(requestID, authorID: authorID, userID: userID)
        
        return myBasic.convoRef.child(convoHash)
    }
	
	@IBAction func goToMessages(sender: UIButton)
	{
        if requestModels[currentIndex].authorID != self.myUserBackend.getUserID() {
            let requestID = requestModels[currentIndex].postID!
            let userID = self.myUserBackend.getUserID()
            self.myRequestBackend.addSelfToAttendees(requestID, myID: userID)
        }
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
			"timestamp": self.myBasic.getTimestamp()
		]
		
		let convoHash = createConvoHash(requestID, authorID: authorID , userID: userID)
		
		// Create a new Conversation with the above information
		let newConvoRef = myBasic.convoRef.child(convoHash)
		
		convoID = newConvoRef.key // make sure that convoID = convoHash
		newConvoRef.setValue(newConvo, withCompletionBlock: {
			(error:NSError?, ref:FIRDatabaseReference!) in
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
                    let  convoVC = segue.destinationViewController as! ConvoViewController
                    convoVC.setIndex(index)
                    break
                }
                index += 1
            }
		}
	}

}