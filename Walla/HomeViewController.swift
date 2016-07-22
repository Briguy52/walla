//
//  HomeViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/23/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Firebase

var masterView: HomeViewController?
var detailView: ViewDetails?
var requestModels: [RequestModel] = [RequestModel]()
var currentIndex: Int = 0
var tagsToFilter: [String] = []

var safeToLoadID: Bool = false

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var noWallas: UILabel!
	@IBOutlet weak var filterButton: UIBarButtonItem!
	
	var cellIdentifier = "ViewWallaCell"
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	let myRequestBackend = RequestBackend()
    let myConvoBackend = ConvoBackend()
	var isInitialLoad = true
	var authorName = ""
    var latitude: Double = 36.0014
    var longitude: Double = 78.9382
	var postsAreExpired: Bool = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        
		self.navigationItem.setLeftBarButtonItem(nil, animated: false)
		
		tableView.delegate = self
		tableView.dataSource = self
		masterView = self
        
        self.reloadData()
		
//		self.checkForMyTags()
	}
    
    func reloadData() {
        if (safeToLoadID) {
            self.myConvoBackend.reloadConvoModels()
            self.myRequestBackend.populateFilter()
            self.myUserBackend.reloadSenderDict()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
        self.observeWithStreams()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
            
		let backgroundImage = UIImage(named: "background")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView?.backgroundView = imageView
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		
		imageView.contentMode = .ScaleAspectFill
		
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
        
        self.observeWithStreams()
		
		//self.noWallasPosts()
	}
	
	func noWallasPosts()
	{
		if requestModels.count == 0
		{
			noWallas.hidden = false
		}
		else
		{
			noWallas.hidden = true
		}
	}
	
	@IBAction func unwindToHomeFromWrite(segue: UIStoryboardSegue)
	{
	}
	
	// Copied from MessagingVC, remainder of code to use is there
	func observeWithStreams() {
        requestModels.removeAll()
        let ref = self.myBasic.requestRef
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            // Check 1) Non-null, 2) Not expired 3) Not duplicate and 4) Filter tags
            if (!(snapshot.value is NSNull) && self.myRequestBackend.checkSnapExpired(snapshot) && !self.myRequestBackend.contains(requestModels, snapshot: snapshot) && self.myRequestBackend.checkTags(snapshot, tags: tagsToFilter)) {
                requestModels.insert(RequestModel(snapshot:snapshot), atIndex:0)
                self.tableView.reloadData()
            }
        })
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return requestModels.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 140.0
	}
	
//	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//		
//		cell.contentView.backgroundColor = UIColor.clearColor()
//		
//		let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 120))
//		
//		whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
//		whiteRoundedView.layer.masksToBounds = false
//		whiteRoundedView.layer.cornerRadius = 2.0
//		whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
//		whiteRoundedView.layer.shadowOpacity = 0.2
//		
//		cell.contentView.addSubview(whiteRoundedView)
//		cell.contentView.sendSubviewToBack(whiteRoundedView)
//	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell :HomeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! HomeCell
		
		let requestModel = requestModels[indexPath.row]
		
		let key = requestModel.authorID
        
		self.myUserBackend.getUserInfo("displayName", userID: key)
		{
			(result: AnyObject) in
			cell.setAuthorName(result as! String)
		}
                
        self.myUserBackend.getUserInfo("profilePicUrl", userID: key)
        {
            (result: AnyObject) in
            cell.setCellImage(NSURL(string: result as! String)!)
        }
		
		cell.userName?.text = requestModel.authorID
		cell.message?.text = requestModel.request
		cell.topics?.text = requestModel.tags.joinWithSeparator(" ")
		cell.timeStamp?.text = "posted " + cell.parseDateFromTime(requestModel.timestamp)
		
		cell.profile.layer.borderWidth = 0.5
		cell.profile.layer.masksToBounds = false
		cell.profile.layer.borderColor = UIColor.blackColor().CGColor
		cell.profile.layer.cornerRadius = cell.profile.frame.height / 2
		cell.profile.clipsToBounds = true
		
		self.noWallasPosts()
		
		let whiteRoundedView : UIView = UIView(frame: CGRectMake(10, 8, self.view.frame.size.width - 20, 149))
		
		whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 0.8])
		whiteRoundedView.layer.masksToBounds = false
		whiteRoundedView.layer.cornerRadius = 4.0
		whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
		whiteRoundedView.layer.shadowOpacity = 0.1
		
		cell.contentView.addSubview(whiteRoundedView)
		cell.contentView.sendSubviewToBack(whiteRoundedView)
		
		return cell
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
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