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
import RxCocoa
import RxSwift
import FirebaseRxSwiftExtensions

class ConvoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	
	@IBOutlet weak var tableView: UITableView!
	
	let myBasic = Basic()
	let myConvoBackend =  ConvoBackend()
	var isInitialLoad = true
	var disposeBag = DisposeBag()
	var messageIndex: Int = 0
	var messageTitleFromWalla = ""
	
	// Model that corresponds to this ViewController
	var convoModels: [ConvoModel] = [ConvoModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
		tableView.delegate = self
		tableView.dataSource = self
		observeWithStreams()
		
		let backgroundImage = UIImage(named: "background")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView?.backgroundView = imageView
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		
		imageView.contentMode = .ScaleAspectFill
		
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
		
		self.messageIndex = 0
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.messageIndex = 0
	}
	
	@IBAction func unwindToMessages(segue: UIStoryboardSegue)
	{
		messageTitleFromWalla = myMessageTitle
		startConvoFromWalla()
	}
	
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1 // previously set to '2' and caused duplicate Convos to show up :(
		// the 2 was because there were 2 sections: resolved and unresolved.  the problem was how we were going to store that
		// thats where the problem comes in from the backend.  Are we storing that info?  how is the andorid team doing it?
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return convoModels.count
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("ConvoCell", forIndexPath: indexPath) as! ConvoCell
		
		let convo = convoModels[indexPath.row] as ConvoModel
		cell.convoModel = convo
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.selectIndex(indexPath.row)
	}
	
	func selectIndex(index: Int)
	{
		self.messageIndex = index
		self.performSegueWithIdentifier("messagingSegue", sender: self)
	}
	
	func startConvoFromWalla()
	{
		self.selectIndex(convoModels.count) //change whats in the function param for where ever the new post is going to be
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return false
	}
	
	// Copied from MessagingVC, remainder of code to use is there
	func observeWithStreams() {
		convoModels.removeAll()
		let myID = myBasic.rootRef.authData.uid
		myBasic.convoRef.rx_observe(FEventType.ChildAdded)
			.filter { snapshot in
				// Note: can also add filters for tags, location, etc.
				return !(snapshot.value is NSNull)
			}
			.filter { snapshot in
				return !self.myConvoBackend.contains(self.convoModels, snapshot: snapshot) // avoids showing duplicate Convos on initial load
			}
			.filter { snapshot in
				// Only return Snapshots with authorID or userID == user's ID
				return (snapshot.value.objectForKey("authorID") as? String == myID || snapshot.value.objectForKey("userID") as? String == myID)
			}
			.map {snapshot in
				return ConvoModel(snapshot: snapshot)
			}
			.subscribeNext({ (convoModel: ConvoModel) -> Void in
				self.convoModels.insert(convoModel, atIndex: 0);
			})
			.addDisposableTo(self.disposeBag)
		
		myBasic.convoRef.rx_observe(FEventType.Value)
			.subscribeNext({ (snapshot: FDataSnapshot) -> Void in
				self.tableView.reloadData()
				self.isInitialLoad = false;
			})
			.addDisposableTo(self.disposeBag)
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let convoIndex: Int = self.messageIndex
		/*if let indexPath = self.tableView.indexPathForSelectedRow {
		convoIndex = indexPath.row
		}*/
		
		if segue.identifier == "messagingSegue"
		{
			let messagingVC = segue.destinationViewController as! MessageViewController
			messagingVC.convoID = self.convoModels[convoIndex].convoID!
		}
	}
	
}