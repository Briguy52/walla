//
//  HomeCell.swift
//  Walla
//
//  Created by Timothy Choh on 6/23/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import QuartzCore

class HomeCell: UITableViewCell {
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var topics: UILabel!
	@IBOutlet weak var timeStamp: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	func setAuthorName(nameToSet: String)
	{
		self.userName.text = nameToSet
	}
	
	func setCellTags(tagsToSet: [String])
	{
		self.topics.text = tagsToSet.joinWithSeparator("")
		//self.topics.sizeThatFits(self.topics.text.width)
	}
	
	func setCellDetails(detailsToSet: String)
	{
		self.message.text = detailsToSet
	}
	
	func setProfileImage(result: String)
	{
			self.profile.setImageWithURL(NSURL(string: result)!)
	}
	
	func parseDateFromTime(time: Double) -> String {
		let postedDate = NSDate(timeIntervalSince1970: time)
		
		let currentDate = NSDate()
		
		let hourMinute: NSCalendarUnit = [.Hour, .Minute]
		let difference = NSCalendar.currentCalendar().components(hourMinute, fromDate: postedDate, toDate: currentDate, options: [])
		var timeDifference: String = ""
		
		if difference.hour < 1
		{
			timeDifference = "\(difference.minute)m"
		}
		else
		{
			timeDifference = "\(difference.hour)h" + " " + "\(difference.minute)m"
		}
		
//		print(timeDifference)
		
		return String(timeDifference + " ago")
	}
}