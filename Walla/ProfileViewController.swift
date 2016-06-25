//
//  ProfileViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func setImage()
	{
		let key = self.myUserBackend.updateDisplayName
		/*self.myUserBackend.getUserInfo("ProfilePicUrl", userID: key)
		{
			(result: String)
		}*/
	}
}