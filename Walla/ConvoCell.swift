//
//  ConvoCell.swift
//  Walla
//
//  Created by Timothy Choh on 6/26/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class ConvoCell: UITableViewCell {
	
	@IBOutlet weak var profile: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var previewLabel: UILabel!
	
	var convoModel: ConvoModel! {
		didSet {
			// TODO: store Author name in addition to AuthorID
			nameLabel.text = convoModel.authorID
			previewLabel.text = convoModel.title
			//            ratingImageView.image = imageForRating(genie.rating)
		}
	}
}
