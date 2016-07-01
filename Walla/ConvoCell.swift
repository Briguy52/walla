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
            
            let myUserBackend = UserBackend()
            myUserBackend.getUserInfo("displayName", userID: convoModel.authorID) {
                (result: AnyObject) in
                self.nameLabel.text = result as! String
            }
            
            let myRequestBackend = RequestBackend()
            myRequestBackend.getRequestValue(convoModel.uniqueID, key: "request") {
                (result: String) in
                self.previewLabel.text = result
            }
            
            myUserBackend.getUserInfo("profilePicUrl", userID: convoModel.authorID) {
                (result: AnyObject) in
                self.profile.setImageWithURL(NSURL(string: result as! String)!)
            }
            
		}
	}
}
