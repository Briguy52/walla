//
//  MainSettings.swift
//  Walla
//
//  Created by Timothy Choh on 6/26/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MainSettings: UIViewController{
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	@IBOutlet weak var newRequestToggle: UISwitch!
	@IBOutlet weak var messageToggle: UISwitch!
	@IBOutlet weak var helpMeResponseToggle: UISwitch!
	@IBOutlet weak var requestResolvedToggle: UISwitch!
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBAction func requestResolvedPressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("requestResolvedNotification", value: self.requestResolvedToggle.on, userID: self.myUserBackend.getUserID())
	}
	@IBAction func newRequestPressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("newRequestNotification", value: self.newRequestToggle.on, userID: self.myUserBackend.getUserID())
	}
	@IBAction func messagePressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("messageNotification", value: self.messageToggle.on, userID: self.myUserBackend.getUserID())
	}
	@IBAction func helpMeResponsePressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("helpMeResponseNotification", value: self.helpMeResponseToggle.on, userID: self.myUserBackend.getUserID())
	}
	
	@IBAction func phoneNumberSavePressed(sender: AnyObject) {
		if let number = self.phoneNumberTextField.text {
            self.myUserBackend.updateUserData("phoneNumber", value: number, userID: self.myUserBackend.getUserID())
		}
		self.phoneNumberSaveButton.hidden = true
		self.dismissKeyboard()
	}
	
	@IBAction func phoneNumberBeginEditing(sender: AnyObject) {
		self.phoneNumberSaveButton.hidden = false
	}
	
	@IBOutlet weak var phoneNumberSaveButton: UIButton!
	
	@IBOutlet weak var phoneNumberTextField: UITextField!
	
	@IBOutlet weak var emailTextField: UITextField!
	
	@IBAction func back(sender: UIBarButtonItem) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideButtons()
		self.initContactInfo()
		self.hideKeyboardWhenTappedAround()
		
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(MainSettings.keyboardWillShow(_:)),
			name: UIKeyboardWillShowNotification,
			object: nil
		)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(MainSettings.keyboardWillHide(_:)),
			name: UIKeyboardWillHideNotification,
			object: nil
		)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func hideButtons() {
		self.phoneNumberSaveButton.hidden = true
		self.emailTextField.userInteractionEnabled = false
	}
	
	func initContactInfo() {
		self.myUserBackend.getUserInfo("email", userID: self.myUserBackend.getUserID()) {
			(result: AnyObject) in
			self.emailTextField.text = result as! String
		}
		self.myUserBackend.getUserInfo("phoneNumber", userID: self.myUserBackend.getUserID()) {
			(result: AnyObject) in
			self.phoneNumberTextField.text = result as! String
		}
	}
	
	func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
		guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
		let keyboardFrame = value.CGRectValue()
		let adjustmentHeight = (CGRectGetHeight(keyboardFrame) + 20) * (show ? 1 : -1)
		scrollView.contentInset.bottom += adjustmentHeight
		scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
	}
 
	func keyboardWillShow(notification: NSNotification) {
		adjustInsetForKeyboardShow(true, notification: notification)
	}
 
	func keyboardWillHide(notification: NSNotification) {
		adjustInsetForKeyboardShow(false, notification: notification)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}