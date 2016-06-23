//
//  HomeCell.swift
//  Walla
//
//  Created by Timothy Choh on 6/23/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

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
}
