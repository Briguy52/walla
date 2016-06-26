//
//  MessageViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

//import UIKit
//import CoreLocation
//import Foundation
//import Firebase
//import RxCocoa
//import RxSwift
//import FirebaseRxSwiftExtensions
//
//class MessageViewController: UITableViewController
//{
//	let myBasic = Basic()
//	var isInitialLoad = true;
//	var disposeBag = DisposeBag()
//	
//	// Model that corresponds to this ViewController
//	var convoModels: [ConvoModel] = [ConvoModel]()
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		self.navigationItem.hidesBackButton = true
//		observeWithStreams()
//	}
//	
//	
//	// MARK: - Table view data source
//	
//	override func numberOfSectionsInTableView(tableView: UITableView) -> Int
//	{
//		return 2
//	}
//	
//	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//	{
//		return convoModels.count
//	}
//	
//	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
//		-> UITableViewCell
//	{
//		let cell = tableView.dequeueReusableCellWithIdentifier("ConvoCell", forIndexPath: indexPath) as! ConvoCell
//		
//		let convo = convoModels[indexPath.row] as ConvoModel
//		cell.convoModel = convo
//		return cell
//	}
//	
//	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//		// Return false if you do not want the specified item to be editable.
//		return true
//	}
//	
//	// Copied from MessagingVC, remainder of code to use is there
//	func observeWithStreams() {
//		let myID = myBasic.rootRef.authData.uid
//		myBasic.convoRef.rx_observe(FEventType.ChildAdded)
//			.filter { snapshot in
//				// Note: can also add filters for tags, location, etc.
//				return !(snapshot.value is NSNull)
//			}
//			.filter { snapshot in
//				// Only return Snapshots with authorID or userID == user's ID
//				return (snapshot.value.objectForKey("authorID") as? String == myID || snapshot.value.objectForKey("userID") as? String == myID)
//			}
//			.map {snapshot in
//				return ConvoModel(snapshot: snapshot)
//			}
//			.subscribeNext({ (convoModel: ConvoModel) -> Void in
//				self.convoModels.insert(convoModel, atIndex: 0);
//			})
//			.addDisposableTo(self.disposeBag)
//		
//		myBasic.convoRef.rx_observe(FEventType.Value)
//			.subscribeNext({ (snapshot: FDataSnapshot) -> Void in
//				self.tableView.reloadData()
//				self.isInitialLoad = false;
//			})
//			.addDisposableTo(self.disposeBag)
//	}
//	
//	
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		var convoIndex: Int = 0
//		if let indexPath = self.tableView.indexPathForSelectedRow {
//			convoIndex = indexPath.row
//		}
//		let messagingVC = segue.destinationViewController as! MessagingViewController
//		messagingVC.convoID = self.convoModels[convoIndex].convoID!
//	}
//	
//}