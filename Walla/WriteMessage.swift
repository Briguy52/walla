//
//  WriteMessage.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase

var tagsToPick = ["#ElementarySchool", "#MiddleSchool", "#HighSchool", "#University", "#Industry", "#LongTermChange", "#MathAndCompSci", "#PartnershipsForChange", "#SocialEntrpreneurship", "#Entrepreneurship", "#STEM+", "#MakerIdeas", "#SuccessStories", "#OnlineLearning", "#Engineering", "#CommunityIntegration", "#GrowingSustainedSTEM"]

class WriteMessage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

	@IBOutlet weak var tagPicker: UIPickerView!
	@IBOutlet weak var addTagButton: UIButton!
	@IBOutlet weak var removeTagButton: UIButton!
	@IBOutlet weak var tagLabel: UILabel!
	@IBOutlet weak var requestBody: UITextField!
	@IBOutlet weak var requestDetails: UITextView!
	@IBOutlet weak var generalLocation: UITextField!
	@IBOutlet weak var holla: UIButton!
	
	var myTitle:String = "default request"
	var myAuthorName:String = ""
	var myDetails:String = "default details"
	var myLatitude: Double = 36.0014
	var myLongitude: Double = 78.9382
    var myLocation: String = "default location"
	var myTags:[String] = ["#STEM+"]
	var myDelayHours: Double = 5
	
	var currentTime = NSDate().timeIntervalSince1970
	//let locManager = CLLocationManager()
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		
		self.tagPicker?.dataSource = self
		self.tagPicker?.delegate = self
        
        self.initRequestDetails()
		
		self.navigationItem.hidesBackButton = false
		self.requestDetails?.layer.borderWidth = 0.2
		self.requestDetails?.layer.borderColor = UIColor.lightGrayColor().CGColor
		
//		self.addTagButton.hidden = true
		
		//self.holla?.userInteractionEnabled = false
		//self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffa160)
		
		//self.hidesBottomBarWhenPushed = true
		
		self.tabBarController?.tabBar.hidden = true
//
//		navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidAppear(animated: Bool) {
		self.viewDidLoad()
	}
	
	func submit()
	{
		self.saveAndUpdate()
		self.resetFields()
		self.tabBarController?.tabBar.hidden = false
		self.dismissKeyboard()
		self.performSegueWithIdentifier("unwindToHomeFromWrite", sender: self)
	}
	
	@IBAction func allFieldsSet(sender: UIButton)
	{
		var tags: Bool = false
		var wish: Bool = false
		var dets: Bool = false
		var locs: Bool = false
		
		let alert = UIAlertView()
		alert.title = "You missed a field"
		alert.addButtonWithTitle("OK")
		
//		print(myTags.count)
//		print(requestBody.text)
//		print(requestDetails.text)
//		print(generalLocation.text)
//		
		if self.myTags.count == 1
		{
			tags = true
		}
		else
		{
			tags = false
		}
		
		if self.requestBody.text!.isEmptyField == false
		{
			wish = true
		}
		else
		{
			wish = false
		}
		
		if self.requestDetails.text!.isEmptyField == false
		{
			dets = true
		}
		else
		{
			dets = false
		}
		
		if self.generalLocation.text!.isEmptyField == false
		{
			locs = true
		}
		else
		{
			locs = false
		}
		
		if tags == true && wish == true && dets == true && locs == true
		{
			self.submit()
		}
		else
		{
			if tags == false
			{
				alert.message = "You forgot to add tags!"
			}
			else if wish == false
			{
				alert.message = "You forgot the wish!"
			}
			else if dets == false
			{
				alert.message = "You forgot the details!"
			}
			else if locs == false
			{
				alert.message = "You forgot the location!"
			}
			else
			{
				alert.message = "Not sure why this showed up"
			}
			
			alert.show()
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
		self.dismissKeyboard()
		self.performSegueWithIdentifier("unwindToHomeFromWrite", sender: self)
	}
	
	func resetFields()
	{
		requestBody?.text = ""
		requestDetails?.text = ""
		generalLocation?.text = ""
		tagLabel?.text = "#STEM+ "
		
	}
	
    func postNewRequest(authorID: String, request: String, additionalDetails: String, latitude: Double, longitude: Double, location: String, resolved: Bool, visible: Bool, tags: [String], expirationDate: Double ) -> Void {
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
	
    // currently not called
	func initRequestInfo() {
		self.tagLabel.text = self.myTags.joinWithSeparator("")
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
		tagsToPick = tags
	}
	
	func setSelectedTags(tags: [String]) {
		self.myTags = tags
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return tagsToPick.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return tagsToPick[row]
	}
	
	func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let titleData = tagsToPick[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
		
		return myTitle
	}
	
	func oneTag()
	{
		if self.myTags.count == 1
		{
			self.addTagButton.hidden = true
			self.removeTagButton.hidden = false
		}
		else
		{
			self.addTagButton.hidden = false
			self.removeTagButton.hidden = true
		}
	}
	
	@IBAction func addTags(sender: UIButton)
	{
		let tag = tagsToPick[self.tagPicker.selectedRowInComponent(0)]
		if tagLabel.text == "Please Enter a Tag"
		{
			tagLabel.text = ""
		}
		self.addTag(tag)
//		self.oneTag()
	}
	
	@IBAction func removeTags(sender: UIButton)
	{
		self.myTags.removeAll()
		self.tagLabel.textColor = UIColor.redColor()
		self.tagLabel.text = "Please Enter a Tag"
//		self.oneTag()
	}
	
	func addTag(tag: String) {
        self.myTags.removeAll()
        self.myTags.append(tag)
        self.tagLabel.text = self.myTags.joinWithSeparator(" ")
	}
}

extension String {
	var isEmptyField: Bool {
		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""
	}
}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}