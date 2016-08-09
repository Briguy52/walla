//
//  WriteMessage.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Firebase
import DropDown

var tagsToPick = ["Food", "Artsy", "School", "Rides", "Games", "Others"]

class WriteMessage: UIViewController, UITextViewDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var topicPicker: UIButton!
	@IBOutlet weak var requestBody: UITextView!
	@IBOutlet weak var generalLocation: UITextField!
	@IBOutlet weak var holla: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var textCounter: UILabel!
	@IBOutlet weak var timePickerButton: UIButton!
	
	let dropDown = DropDown()
	
	lazy var dropDowns: [DropDown] = {
		return [self.dropDown]
	}()
	
	var myTitle:String = "default request"
	var myAuthorName:String = ""
	var myDetails:String = "default details"
	var myLatitude: Double = 36.0014
	var myLongitude: Double = 78.9382
	var myLocation: String = "default location"
	var myTags:[String] = ["Choose A Topic"]
	var myDelayHours: Double = 0.5
	var myStartTime: Double = 0.0
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		
//		self.initRequestDetails()
        self.myStartTime = self.myBasic.getTimestamp()
		
		customizeDropDown(self)
		self.setupDropDown()
		
		textCounter.text = "Character count: 73"
		
		self.navigationItem.hidesBackButton = false
		//		self.requestDetails?.layer.borderWidth = 0.2
		//		self.requestDetails?.layer.borderColor = UIColor.lightGrayColor().CGColor
		
		//		self.addTagButton.hidden = true
		
		//self.holla?.userInteractionEnabled = false
		//self.holla?.titleLabel?.textColor = UIColor(netHex: 0xffa160)
		
		//self.hidesBottomBarWhenPushed = true
		
		self.tabBarController?.tabBar.hidden = true
		//
		//		navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.hidden = true
	}
	
//	func textFieldDidBeginEditing(textField: UITextField) {
//		scrollView.setContentOffset(CGPointMake(0, 150), animated: true)
//	}
//	
//	func textFieldShouldReturn(textField: UITextField) -> Bool {
//		textField.resignFirstResponder()
//		return true
//	}
//	
//	func textFieldDidEndEditing(textField: UITextField) {
//		scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//	}
//	
//	func textViewDidBeginEditing(textView: UITextView) {
//		scrollView.setContentOffset(CGPointMake(0, 25), animated: true)
//	}
//	
//	func textViewDidEndEditing(textView: UITextView) {
//		scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//	}
	
	@IBAction func chooseTopic(sender: AnyObject) {
		dropDown.show()
	}
	
	func setupDropDown() {
		dropDown.anchorView = topicPicker
		dropDown.bottomOffset = CGPoint(x: 0, y: topicPicker.bounds.height)
		dropDown.dataSource = tagsToPick
		//dropDown.selectRowAtIndex(0)
		dropDown.selectionAction = { [unowned self] (index, item) in self.topicPicker.setTitle(item, forState: .Normal)}
		//print(dropDown.indexForSelectedRow!)
	}
	
	func customizeDropDown(sender: AnyObject) {
		let appearance = DropDown.appearance()
		
		appearance.cellHeight = 60
		appearance.backgroundColor = UIColor(white: 1, alpha: 1)
		appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
		appearance.cornerRadius = 10
		appearance.shadowColor = UIColor(white: 0.8, alpha: 1)
		appearance.shadowOpacity = 0.9
		appearance.shadowRadius = 25
		appearance.animationduration = 0.25
		appearance.textColor = .darkGrayColor()
		//		appearance.textFont = UIFont(name: "Georgia", size: 14)
	}
	
	func checkRemainingChars() {
		let allowedChars = 73
		let charsInTextView = -requestBody.text.characters.count
		let remainingChars = allowedChars + charsInTextView
		
		textCounter.text = "Remaining characters: " + String(remainingChars)
		
		if remainingChars <= allowedChars {
			textCounter.textColor = UIColor.blackColor()
		}
		if remainingChars <= 20 {
			textCounter.textColor = UIColor.orangeColor()
		}
		if remainingChars <= 10 {
			textCounter.textColor = UIColor.redColor()
		}
	}
	
	func submit()
	{
		self.saveAndUpdate()
		self.resetFields()
		self.tabBarController?.tabBar.hidden = false
		self.dismissKeyboard()
		self.performSegueWithIdentifier("unwindToHomeFromWrite", sender: self)
	}
	
	func allFieldsSet(sender: UIButton)
	{
		var tags: Bool = false
		var wish: Bool = false
		var dets: Bool = false
		var locs: Bool = false
		
		let allowedChars = 73
		let charsInTextView = -requestBody.text.characters.count
		let remainingChars = allowedChars + charsInTextView
		
		let alert = UIAlertView()
		alert.title = "You missed a field"
		alert.addButtonWithTitle("OK")
		
		//		print(myTags.count)
		//		print(requestBody.text)
		//		print(requestDetails.text)
		//		print(generalLocation.text)
		
		if let selected = self.dropDown.selectedItem {
			self.myTags.removeAll()
			self.myTags.append(selected)
			print("selected \(selected)")
			print("myTags: \(self.myTags)")
		}

		print(self.myTags[0])
		if self.myTags[0] != "Choose A Topic" { tags = true } else { tags = false }
		
		if self.requestBody.text!.isEmptyField == false { wish = true } else { wish = false }
		
		//if self.requestDetails.text!.isEmptyField == false { dets = true } else { dets = false }
		
		if self.generalLocation.text!.isEmptyField == false { locs = true } else { locs = false }
		
		if tags == true && wish == true && dets == true && locs == true && remainingChars > -1 {
			self.submit()
		}
		else {
			if tags == false {
				alert.title = "You forgot to add tags!"
			}
			else if wish == false {
				alert.title = "You forgot the wish!"
			}
//			else if dets == false {
//				alert.title = "You forgot the details!"
//			}
			else if locs == false {
				alert.title = "You forgot the location!"
			}
			else if remainingChars < 0 {
				alert.title = "Too many characters in What You Want To Do!"
			}
			else {
				alert.title = "Not sure why this showed up. Please try again."
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
		generalLocation?.text = ""
		textCounter?.text = "Character count: 73"
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
			"tags": [self.myTags[0]],
			"timestamp": myStartTime,//self.myBasic.getTimestamp(),
			"expirationDate": expirationDate
		]
		
		let toHash = authorID + request
		let afterHash = String(toHash.hashValue)
		
		let newPostRef = myBasic.requestRef.child(afterHash) // generate a unique ID for this post
		let postId = newPostRef.key
		newPostRef.setValue(newPost, withCompletionBlock: {
			(error:NSError?, ref:FIRDatabaseReference!) in
			if (error != nil) {
				print("Post data could not be saved.")
			} else {
				print("Post data saved successfully!")
				self.myUserBackend.updateUserPosts(postId, userID: authorID)
			}
		})
	}
	
	@IBAction func pickTime(sender: AnyObject) {
		DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
			(time) -> Void in
//			myStartTime = NSDate(timeIntervalSince1970: time)
            print("womp pick time in")
            print(time)
			let formatter = NSDateFormatter()
			formatter.timeStyle = .ShortStyle
			let newTime = formatter.stringFromDate(time!)
			self.timePickerButton.setTitle(newTime, forState: .Normal)
		}
	}
	
	//init functions
	func setAuthorName(name: String) {
		self.myAuthorName = name
	}
	
	func calcHoursFromNow(expiry: Double) -> Double {
		let difference = expiry - self.myBasic.getTimestamp()
		return (difference / (60 * 60 ))
	}
	
	func calcExpirationDate(hours: Double) -> Double {
		return ( self.myBasic.getTimestamp() + hours * 60 * 60 )
	}
	
	
	// Begin listeners for input text fields and text views (Brian)
	
//	@IBAction func requestEditingDidEnd(sender: UITextField) {
//		if let text = self.requestDetails.text {
//			self.myDetails = text
//		}
//	}
	
	func textViewDidChange(textView: UITextView) {
		checkRemainingChars()
		if let text = self.requestBody.text {
			self.myTitle = text
		}
	}
	
//	func initRequestDetails() {
//		self.requestDetails.delegate = self
//	}
	
	@IBAction func locationEditingChanged(sender: UITextField) {
		if let text = self.generalLocation.text {
			self.myLocation = text
		}
	}
	
	@IBAction func locationEditingDidEnd(sender: UITextField) {
		if let text = self.generalLocation.text {
			self.myLocation = text
		}
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