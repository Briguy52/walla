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
    
    let myBasic = Basic()
    let myUserBackend = UserBackend()
    let myConvoBackend = ConvoBackend()
	
	var convoModel: ConvoModel! {
		didSet {
            
            let userID = self.myBasic.rootRef.authData.uid
            let otherID = self.myConvoBackend.printNotMe(convoModel, userID: userID)
            
            self.nameLabel.text = self.myUserBackend.getSenderName(otherID)

            let myRequestBackend = RequestBackend()
            myRequestBackend.getRequestValue(convoModel.uniqueID, key: "request") {
                (result: String) in
                self.previewLabel.text = result
            }
            
            myUserBackend.getUserInfo("profilePicUrl", userID: otherID) {
                (result: AnyObject) in
                self.profile.setImageWithURL(NSURL(string: result as! String)!)
            }
            
		}
	}
}
