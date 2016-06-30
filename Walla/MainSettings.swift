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
	
	@IBAction func requestResolvedPressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("requestResolvedNotification", value: self.requestResolvedToggle.on, userID: myBasic.rootRef.authData.uid)
	}
	@IBAction func newRequestPressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("newRequestNotification", value: self.newRequestToggle.on, userID: myBasic.rootRef.authData.uid)
	}
	@IBAction func messagePressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("messageNotification", value: self.messageToggle.on, userID: myBasic.rootRef.authData.uid)
	}
	@IBAction func helpMeResponsePressed(sender: AnyObject) {
		self.myUserBackend.updateNotificationSetting("helpMeResponseNotification", value: self.helpMeResponseToggle.on, userID: myBasic.rootRef.authData.uid)
	}
	
	@IBAction func phoneNumberSavePressed(sender: AnyObject) {
		if let number = self.phoneNumberTextField.text {
            self.myUserBackend.updateUserData("phoneNumber", value: number, userID: myBasic.rootRef.authData.uid)
		}
		self.phoneNumberSaveButton.hidden = true
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
	}
	
	func hideButtons() {
		self.phoneNumberSaveButton.hidden = true
		self.emailTextField.userInteractionEnabled = false
	}
	
	func initContactInfo() {
		self.myUserBackend.getUserInfo("email", userID: self.myBasic.rootRef.authData.uid) {
			(result: String) in
			self.emailTextField.text = result
		}
		self.myUserBackend.getUserInfo("phoneNumber", userID: self.myBasic.rootRef.authData.uid) {
			(result: String) in
			self.phoneNumberTextField.text = result
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}