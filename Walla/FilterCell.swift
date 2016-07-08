//
//  FilterCell.swift
//  Walla
//
//  Created by Timothy Choh on 7/8/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
	
	@IBOutlet weak var topicTitle: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func setTitle(titleToSet: String) {
		self.topicTitle.text = titleToSet
	}
}