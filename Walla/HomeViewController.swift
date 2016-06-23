//
//  HomeViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/23/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	
	var cellIdentifier = "ViewWallCell"
	
	var usernames: [String] = []
	var messages: [String] = []
	var topics: [String] = []
	
	func ViewDidLoad()
	{
		super.viewDidLoad()
		
		usernames = ["user1", "user2", "user3", "user4"]
		messages = ["m1", "m2", "m3", "m4"]
		topics = ["t1", "t2", "t3", "t4"]
		
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = usernames.count
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellidentifer, forIndexPath: indexPath) as! HomeCell
		
		cell.userName?.text = usernames[indexPath.row]
		cell.message?.text = messages[indexPath.row]
		cell.topics?.text = topics[indexPath.row]
		
		return cell
	}
}