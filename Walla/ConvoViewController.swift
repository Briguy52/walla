//
//  ConvoViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/26/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Firebase

var fromWalla: Bool = false
var convoModels: [ConvoModel] = [ConvoModel]() // global variable for ViewDetails.swift access


class ConvoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	
	@IBOutlet weak var tableView: UITableView!
	
	let myBasic = Basic()
    let myUserBackend = UserBackend()
	let myConvoBackend =  ConvoBackend()
//	var isInitialLoad = true
	var messageIndex: Int = 0
	var convoFromWalla = ""
	var indexFromWalla = -1
    
	
	// Model that corresponds to this ViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
		tableView.delegate = self
		tableView.dataSource = self

        self.observeWithStreams()
		
		let backgroundImage = UIImage(named: "background")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView?.backgroundView = imageView
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		
		imageView.contentMode = .ScaleAspectFill
		
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if fromWalla {
            self.selectIndex(self.messageIndex)
            fromWalla = false
        }
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//observeWithStreams()
	}
	
	@IBAction func unwindToMessages(segue: UIStoryboardSegue) {
		convoFromWalla = convoIDFromHome
		fromWalla = true
	}
    
    func setIndex(index: Int) {
        self.messageIndex = index 
    }
	
	func startConvoFromWalla() {
		self.selectIndex(self.messageIndex) //change whats in the function param for where ever the new post is going to be
	}
	
	func selectIndex(index: Int) {
		self.messageIndex = index
        print("ConvoVC selected index of " + String(self.messageIndex))
		fromWalla = false
		self.performSegueWithIdentifier("messagingSegue", sender: self)
	}
	
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1 // previously set to '2' and caused duplicate Convos to show up :(
		// the 2 was because there were 2 sections: resolved and unresolved.  the problem was how we were going to store that
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return convoModels.count
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ConvoCell", forIndexPath: indexPath) as! ConvoCell
		
		let convo = convoModels[indexPath.row] as ConvoModel
		cell.convoModel = convo
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.selectIndex(indexPath.row)
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return false
	}
	
	// Copied from MessagingVC, remainder of code to use is there
	func observeWithStreams() {
		convoModels.removeAll()
        let myID = self.myUserBackend.getUserID()
        let ref = self.myBasic.convoRef
        
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            // Check 1) Non-null 2) Not a duplicate and 3) Relevant to User
            if (!(snapshot.value is NSNull) && !self.myConvoBackend.contains(convoModels, snapshot:snapshot) && (self.myConvoBackend.checkSnapIncludesUid(snapshot, uid: myID)) ) {
                convoModels.insert(ConvoModel(snapshot:snapshot), atIndex:0)
                self.tableView.reloadData()
            }
        })
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navVc = segue.destinationViewController as! UINavigationController
        let chatVc = navVc.viewControllers.first as! MessageViewController 
//        let chatVc = segue.destinationViewController as! MessageViewController
        let userID = self.myUserBackend.getUserID()
        let convoModel = convoModels[self.messageIndex]
        
        chatVc.senderId = userID
        chatVc.convoID = convoModel.convoID!
        chatVc.setConversationTitle("Talking to " + self.myUserBackend.getSenderName(self.myConvoBackend.printNotMe(convoModel, userID: userID)))
        chatVc.senderDisplayName = ""
	}
	
}