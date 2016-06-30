//
//  WriteMessage.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

class WriteMessage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

	@IBOutlet weak var tagPicker: UIPickerView!
	@IBOutlet weak var addTagButton: UIButton!
	@IBOutlet weak var removeTagButton: UIButton!
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
    var myLocation: String = "Anonymous location"
	var myUrgency: String = "normal"
	var myTags:[String] = ["#General "]
	var myDelayHours: Double = 5
	
	var currentTime = NSDate().timeIntervalSince1970
	//let locManager = CLLocationManager()
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	var tagsToPick = ["#Elementary School", "#Middle School", "#High School", "#University", "#Inudstry", "#Long Term Change", "#Math and Comp Sci", "#Partnerships for Change", "#Social Entrpreneurship", "#Entrepreneurship", "#STEM+", "#Maker Ideas", "#Success Stories", "#Online Learning", "#Engineering", "#Community Integration", "#Growing Sustained STEM"]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tagPicker?.dataSource = self
		self.tagPicker?.delegate = self
        
        self.initRequestDetails()
		
		self.navigationItem.hidesBackButton = false
		self.requestDetails?.layer.borderWidth = 0.2
		self.requestDetails?.layer.borderColor = UIColor.lightGrayColor().CGColor
		
		self.holla?.userInteractionEnabled = false
		//self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffa160)
		
		//self.hidesBottomBarWhenPushed = true
		
		self.tabBarController?.tabBar.hidden = true
//
//		navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidAppear(animated: Bool) {
		self.viewDidLoad()
	}
	
	
	@IBAction func submit(sender: UIButton) {
		self.saveAndUpdate()
		self.resetFields()
		self.tabBarController?.tabBar.hidden = false
		tabBarController?.selectedIndex = 0
	}
	
	
	@IBAction func allFieldsSet(sender: AnyObject) {
		if !requestBody.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty && !requestDetails.text.isEmpty && !generalLocation.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty && myTags.count > 1
		{
			self.holla?.userInteractionEnabled = true
			self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffffff)
		}
	}
	
    // TODO: link up location with Tim's UI text field
	func saveAndUpdate() {
        self.postNewRequest(self.myUserBackend.getUserID(), request: self.myTitle, additionalDetails: self.myDetails, latitude: self.myLatitude, longitude: self.myLongitude, location: self.myLocation, resolved: false, visible: true, tags: self.myTags, expirationDate: self.calcExpirationDate(self.myDelayHours))
	}
	
	
	@IBAction func cancelWalla(sender: AnyObject)
	{
		self.tabBarController?.tabBar.hidden = false
		self.resetFields()
		tabBarController?.selectedIndex = 0
	}
	
	func resetFields()
	{
		requestBody?.text = ""
		requestDetails?.text = ""
		generalLocation?.text = ""
		tagLabel?.text = "#General "
		
	}
	
    func postNewRequest(authorID: String, request: String, additionalDetails: String, latitude: String, longitude: String, location: String, resolved: Bool, visible: Bool, tags: [String], expirationDate: Double ) -> Void {
	_ = "tags"
	
	let newPost = [
        "authorID": authorID,
        "request": request,
        "additionalDetails": additionalDetails,
		"latitude": latitude,
		"longitude": longitude,
		"location": location,
		"resolved": resolved,
		"visible": visible,
		"tags": tags,
		"timestamp": currentTime,
		"expirationDate": expirationDate
	]
	
	let toHash = authorID + request
	let afterHash = String(toHash.hashValue)
	
	let newPostRef = myBasic.requestRef.childByAppendingPath(afterHash) // generate a unique ID for this post
	let postId = newPostRef.key
	newPostRef.setValue(newPost, withCompletionBlock: {
		(error:NSError?, ref:Firebase!) in
		if (error != nil) {
			print("Post data could not be saved.")
		} else {
			print("Post data saved successfully!")
			self.myUserBackend.updateUserPosts(postId, userID: authorID)
		}
	})
}
	
	//init functions
	func setAuthorName(name: String) {
		self.myAuthorName = name
		//self.name.text = self.myAuthorName
	}
	
	func initRequestInfo() {
		self.tagLabel.text = self.myTags.joinWithSeparator("")
//		self.detailTextInput.text = self.myDetails
//		self.name.text = self.myAuthorName
//		self.expirationNumber.text = "Expire in: \(Int(myDelayHours)) hours" // Make this a function
	}
	
	func calcHoursFromNow(expiry: Double) -> Double {
		let difference = expiry - NSDate().timeIntervalSince1970
		return (difference / (60 * 60 ))
	}
	
	func calcExpirationDate(hours: Double) -> Double {
		return ( NSDate().timeIntervalSince1970 + hours * 60 * 60 )
	}
	
    
    // Begin listeners for input text fields and text views (Brian)
    
    @IBAction func requestEditingDidEnd(sender: UITextField) {
        print("womp request editing did end")
        if let text = self.requestBody.text {
            self.myTitle = text
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if let text = self.requestDetails.text {
            self.myDetails = text
        }
    }
    
    func initRequestDetails() {
        self.requestDetails.delegate = self
    }
    
    @IBAction func locationEditingDidEnd(sender: UITextField) {
        if let text = self.generalLocation.text {
            self.myLocation = text
        }
    }
    
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
		if tagLabel.text == "Please Enter a Tag"
		{
			tagLabel.text = ""
		}
		self.addTag(tag)
	}
	
	@IBAction func removeTags(sender: UIButton)
	{
		self.myTags.removeAll()
		self.tagLabel.textColor = UIColor.redColor()
		self.tagLabel.text = "Please Enter a Tag"
	}
	
	func addTag(tag: String) {
		if (!self.myTags.contains(tag)) {
			self.myTags.append(tag)
			self.tagLabel.text = self.myTags.joinWithSeparator(" ")
		}
	}
}