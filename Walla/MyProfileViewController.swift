//
//  MyProfileViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var username: UILabel!
	@IBOutlet weak var points: UILabel!
	@IBOutlet weak var myHollas: UIButton!
	@IBOutlet weak var myWallas: UIButton!
	@IBOutlet weak var settings: UIButton!
	@IBOutlet weak var myTopics: UIButton!
	@IBOutlet weak var logout: UIButton!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.hidesBackButton = true
		
		self.setImage()
		self.setTotalPoints()
		self.setNameAndTitle()
	}
	
	func setImage()
	{
		let key = self.myUserBackend.updateDisplayName
		/*self.myUserBackend.getUserInfo("ProfilePicUrl", userID: key)
		{
			(result: String) in self.profile.setImageWithURL(NSURL(string: result)!)
		}*/
	}
	
	func setTotalPoints()
	{
		let random = arc4random_uniform(20) + 10
		self.points?.text = "Points: " + String(random)
	}
	
	func setNameAndTitle()
	{
		let key=self.myUserBackend.getUserID()
		self.myUserBackend.getUserInfo("DisplayName", userID: key)
		{
			(result: String) in self.username.text = result
		}
	}
}