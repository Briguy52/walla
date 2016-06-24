//
//  WriteMessage.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class WriteMessage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var tagPicker: UIPickerView!
	@IBOutlet weak var addTagButton: UIButton!
	@IBOutlet weak var tagLabel: UILabel!
	@IBOutlet weak var requestBody: UITextField!
	@IBOutlet weak var requestDetails: UITextView!
	@IBOutlet weak var generalLocation: UITextField!
	@IBOutlet weak var holla: UIButton!
	
	var myTitle:String = ""
	var myAuthorName:String = ""
	var myDetails:String = "womp"
	var myLatitude: String = "36.0014"
	var myLongitude: String = "78.9382"
	var myUrgency: String = "normal"
	var myTags:[String] = ["General\n"]
	var myDelayHours: Double = 5
	
	var currentTime = NSDate().timeIntervalSince1970
	//let locManager = CLLocationManager()
	
	var tagsToPick = ["Math", "ACT", "Working Out", "Cooking", "Music", "Video Games", "Board Games", "SAT", "MCAT", "Money", "Vehicles", "Running", "History", "Tech"]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tagPicker.dataSource = self
		self.tagPicker.delegate = self
		
		self.navigationItem.hidesBackButton = true
		self.requestDetails!.layer.borderWidth = 0.2
		self.requestDetails!.layer.borderColor = UIColor.lightGrayColor().CGColor
		
		self.holla?.userInteractionEnabled = false
		//self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffa160)
	}
	
	
	@IBAction func allFieldsSet(sender: AnyObject) {
		if !requestBody.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty && !requestDetails.text.isEmpty && !generalLocation.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
		{
			self.holla?.userInteractionEnabled = true
			self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffffff)
		}
	}
	
//	func saveAndUpdate() {
//		self.postNewRequest(self.myTitle, content: self.myDetails, authorID: self.myUserBackend.getUserID(), latitude: self.myLatitude, longitude: self.myLongitude, urgency: self.myUrgency, tags: self.myTags, expirationDate: self.calcExpirationDate(self.myDelayHours))
//	}
	
	func resetFields()
	{
		requestBody?.text = ""
		requestDetails?.text = ""
		generalLocation?.text = ""
		tagLabel?.text = "Genera"
		
	}
	
//	func postNewRequest(title: String, content: String, authorID: String, latitude: String, longitude: String, urgency: String, tags: [String], expirationDate: Double ) -> Void {
//		_ = "tags"
//		
//		let newPost = [
//			"title":title,
//			"content": content,
//			"authorID": authorID,
//			"latitude": latitude,
//			"longitude": longitude,
//			"urgency": urgency,
//			"tags": tags,
//			"timestamp": currentTime,
//			"expirationDate": expirationDate
//		]
//		
//		let toHash = authorID + title
//		let afterHash = String(toHash.hashValue)
//		
//		let newPostRef = myBasic.postRef.childByAppendingPath(afterHash) // generate a unique ID for this post
//		let postId = newPostRef.key
//		newPostRef.setValue(newPost, withCompletionBlock: {
//			(error:NSError?, ref:Firebase!) in
//			if (error != nil) {
//				print("Post data could not be saved.")
//			} else {
//				print("Post data saved successfully!")
//				self.myUserBackend.updateUserPosts(postId, userID: authorID)
//			}
//		})
//	}
	
	//init functions
	func setAuthorName(name: String) {
		self.myAuthorName = name
		//self.name.text = self.myAuthorName
	}
	
	func initRequestInfo() {
		self.tagLabel.text = self.myTags.joinWithSeparator(" ")
		//self.detailTextInput.text = self.myDetails
		//self.name.text = self.myAuthorName
		//self.expirationNumber.text = "Expire in: \(Int(myDelayHours)) hours" // Make this a function
	}
	
	func calcHoursFromNow(expiry: Double) -> Double {
		let difference = expiry - NSDate().timeIntervalSince1970
		return (difference / (60 * 60 ))
	}
	
	func calcExpirationDate(hours: Double) -> Double {
		return ( NSDate().timeIntervalSince1970 + hours * 60 * 60 )
	}
	
//	@IBAction func requestTitleEditingDidEnd(sender: AnyObject) {
//		if let title = self.requestTitleTextField.text {
//			self.myTitle = title
//		}
//	}
	
	
	//tag functions
	func setPossibleTags(tags: [String]) {
		self.tagsToPick = tags
	}
	
	func setSelectedTags(tags: [String]) {
		self.myTags = tags
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.tagsToPick.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.tagsToPick[row]
	}
	
	func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let titleData = self.tagsToPick[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
		
		return myTitle
	}
	
	@IBAction func addTags(sender: UIButton)
	{
		let tag = self.tagsToPick[self.tagPicker.selectedRowInComponent(0)]
		self.addTag(tag)
	}
	
	func addTag(tag: String) {
		if (!self.myTags.contains(tag)) {
			self.myTags.append(tag);
			self.tagLabel.text = self.myTags.joinWithSeparator("# ")
		}
	}
}