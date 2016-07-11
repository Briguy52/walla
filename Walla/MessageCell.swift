//
//  MessageCell.swift
//  Walla
//
//  Created by Brian Lin on 7/11/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    
    var messageModel: MessageModel! {
        didSet {
            
            let myUserBackend = UserBackend()
            
            self.previewLabel.text = messageModel.text 
            myUserBackend.getUserInfo("displayName", userID: messageModel.sender) {
                (result: AnyObject) in
                self.nameLabel.text = result as! String
            }
            
            myUserBackend.getUserInfo("profilePicUrl", userID: messageModel.sender) {
                (result: AnyObject) in
                self.profile.setImageWithURL(NSURL(string: result as! String)!)
            }
            
        }
    }
}
