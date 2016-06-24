//
//  ViewDetails.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class ViewDetails: UIViewController {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var additional: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var tags: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.hidesBackButton = false
		
		self.initRequestInfo()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		//if requestModels.count == 0 {
		//	return
		//}
	}
	
	func initRequestInfo()
	{
		//let requestModel = requestModels[currentIndex]
		//self.profile?.UIImage
		
		self.profile?.layer.borderWidth = 0.75
		self.profile?.layer.masksToBounds = false
		self.profile?.layer.borderColor = UIColor.blackColor().CGColor
		self.profile?.layer.cornerRadius = self.profile.frame.height / 4
		self.profile?.clipsToBounds = true
		
		self.message?.text = "ello this is a test" //requestModel.title
		self.timestamp?.text = "posted just now" //requestModel.time
		self.additional?.text = "additional text" //requestModel.content
		self.location?.text = "some random location and time" //requestModel.location
		self.tags?.text = "#general #Comp Sci" //requestModel.tags.joinWithSeperator("# ")
	}
	
	@IBAction func goBack(sender: AnyObject) {
		self.tabBarController?.selectedIndex = 0
	}
	
	@IBAction func startConvo(sender: AnyObject) {
	}
}