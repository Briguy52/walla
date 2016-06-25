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
	
	func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.hidesBackButton = true
		
		
	}
	
	func setImage()
	{
		let key = self.myUserBackend.updateDisplayName
		/*self.myUserBackend.getUserInfo("ProfilePicUrl", userID: key)
		{
		(result: String)
		}*/
	}
	
	func setTotalPoints()
	{
		let random = arc4random_uniform(20) + 10
		self.points?.text = "Points: " + String(random)
	}
}