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
	
	var cellIdentifier = "ViewWallaCell"
	
	var currentIndex: Int = 0
	
	var usernames: [String] = ["user1", "user2", "user3", "user4"]
	var messages: [String] = ["m1", "m2", "m3", "m4"]
	var topics: [String] = ["t1", "t2", "t3"]
	
	func ViewDidLoad()
	{
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backgroundImage = UIImage(named: "background")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView?.backgroundView = imageView
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		
		imageView.contentMode = .ScaleAspectFit
		
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = usernames.count
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell :HomeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! HomeCell
		
		cell.userName?.text = self.usernames[indexPath.row]
		cell.message?.text = self.messages[indexPath.row]
		cell.topics?.text = self.topics.joinWithSeparator(", ")
		
		cell.profile.layer.borderWidth = 0.5
		cell.profile.layer.masksToBounds = false
		cell.profile.layer.borderColor = UIColor.blackColor().CGColor
		cell.profile.layer.cornerRadius = cell.profile.frame.height / 2
		cell.profile.clipsToBounds = true
		
		return cell
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		self.performSegueWithIdentifier("showDetail", sender: nil)
		
	}

	@IBAction func openMenu(sender: AnyObject) {
		performSegueWithIdentifier("openMenu", sender: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			if let indexPath = self.tableView.indexPathForSelectedRow {
				currentIndex = indexPath.row
			}
		}
		if segue.identifier == "openMenu" {
			if let destinationViewController = segue.destinationViewController as? MenuViewController {
				destinationViewController.transitioningDelegate = self
			}
		}
	}
}

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return PresentMenuAnimator()
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return DismissMenuAnimator()
	}
}