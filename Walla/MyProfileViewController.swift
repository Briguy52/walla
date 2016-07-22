//
//  MyProfileViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

var userNeedsTags: Bool = false

class MyProfileViewController: UIViewController {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var points: UILabel!
	@IBOutlet weak var myHollas: UIButton!
	@IBOutlet weak var myWallas: UIButton!
	@IBOutlet weak var settings: UIButton!
	@IBOutlet weak var myTopics: UIButton!
	@IBOutlet weak var logout: UIButton!
	@IBOutlet weak var buttonViews: UIView!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		
		self.navigationItem.hidesBackButton = true
		
		self.profile?.layer.borderWidth = 0.75
		self.profile?.layer.masksToBounds = false
		self.profile?.layer.borderColor = UIColor.blackColor().CGColor
		self.profile?.layer.cornerRadius = self.profile.frame.height / 4
		self.profile?.clipsToBounds = true
		
		self.setImage()
		self.setTotalPoints()
		self.setNameAndTitle()
	}
	
//	override func viewDidAppear(animated: Bool) {
//		super.viewDidAppear(animated)
//		if userNeedsTags {
//			performSegueWithIdentifier("showTopics", sender: self)
//			userNeedsTags = false
//		}
//	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		//self.setButtonSizes()
	}
	
	@IBAction func unwindToTopicsFromHome(segue: UIStoryboardSegue) {
	}
	
	/*func setButtonSizes() {
		let screenSize = buttonViews.frame.size
		self.myHollas.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
		self.myWallas.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
		self.settings.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
		self.myTopics.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
		self.logout.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
	}*/
	
	@IBAction func settings(sender: AnyObject) {
		performSegueWithIdentifier("openSettings", sender: nil)
	}
	
	@IBAction func myTopics(sender: AnyObject) {
		performSegueWithIdentifier("showTopics", sender: nil)
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
	
	func setTotalPoints()
	{
		//let random = arc4random_uniform(20) + 10
		//self.points?.text = "Points: " + String(random)
		self.points?.text = ""
	}
	
	func setNameAndTitle()
	{
		self.myUserBackend.getUserInfo("displayName", userID: self.myUserBackend.getUserID())
		{
			(result: AnyObject) in
            self.username.text = result as! String
		}
	}
	
	@IBAction func changeUsername(sender: UITextField) {
		if let newName = self.username.text {
			self.myUserBackend.updateUserData("displayName", value: newName, userID: self.myUserBackend.getUserID())
		}
	}
	
	
	@IBAction func logout(sender: UIButton) {
		myUserBackend.logout()
	}
}