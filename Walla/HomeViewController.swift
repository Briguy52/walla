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
import RxCocoa
import RxSwift
import FirebaseRxSwiftExtensions

var masterView: HomeViewController?
var detailView: ViewDetails?
var requestModels: [RequestModel] = [RequestModel]()
var currentIndex: Int = 0
var tagsToFilter: [String] = []

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
	var disposeBag = DisposeBag()
	var authorName = ""
    var latitude: Double = 36.0014
    var longitude: Double = 78.9382
	var postsAreExpired: Bool = false
	
	// TODO: stores these tags in the Users ref
	//var tagsToFilter: [String] = ["All"]
	
	//	var usernames: [String] = ["user1", "user2", "user3", "user4"]
	//	var messages: [String] = ["m1", "m2", "m3", "m4"]
	//	var topics: [String] = ["t1", "t2", "t3"]
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        
		self.navigationItem.setLeftBarButtonItem(nil, animated: false)
		
		tableView.delegate = self
		tableView.dataSource = self
		masterView = self
		
		self.checkForMyTags()
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.myConvoBackend.reloadConvoModels()
        self.myRequestBackend.populateFilter()
        self.myUserBackend.reloadSenderDict()

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
	
	func checkForMyTags() {
		let refToTry = self.myBasic.userRef.childByAppendingPath(self.myUserBackend.getUserID())
		
		refToTry.observeEventType(.Value, withBlock: { snapshot in
			// Confirm that User has preset tags
			if snapshot.value.objectForKey("tags") == nil {
				userNeedsTags = true
				self.performSegueWithIdentifier("unwindToTopicsFromHome", sender: self)
			}
		})
	}
	
	// Copied from MessagingVC, remainder of code to use is there
	func observeWithStreams() {
		requestModels.removeAll()
		
		self.myBasic.requestRef.rx_observe(FEventType.ChildAdded)
			.filter { snapshot in
				return !(snapshot.value is NSNull) // hide Null requests
			}
			.filter { snapshot in
				if let exp = snapshot.value.objectForKey("expirationDate")?.doubleValue { // hide expired Requests
					return exp >= self.myBasic.getTimestamp()
				}
				return false
			}
            .filter { snapshot in
                
                if tagsToFilter.contains("All") || tagsToFilter.contains("Time") {
                    return true
                }
                
                var ret = true
                if let tags = snapshot.value.objectForKey("tags") as? [String] {
                    for tag in tagsToFilter {
                        if (!tags.contains(tag)) {
                            ret = false
                        }
                    }
                }
                return ret
            }
			.filter { snapshot in
				return !self.myRequestBackend.contains(requestModels, snapshot: snapshot) // avoids showing duplicate Requests on initial load
			}
			.map { snapshot in
				return RequestModel(snapshot: snapshot)
			}
			.subscribeNext({ (requestModel: RequestModel) -> Void in
				requestModels.insert(requestModel, atIndex: 0);
			})
			.addDisposableTo(self.disposeBag)
		
		self.myBasic.requestRef.rx_observe(FEventType.Value)
			.subscribeNext({ (snapshot: FDataSnapshot) -> Void in
				self.tableView.reloadData()
				self.isInitialLoad = false;
			})
			.addDisposableTo(self.disposeBag)
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

		
		/*self.myUserBackend.getUserInfo("ProfilePicUrl", userID: self.myUserBackend.getUserID())
		{
			(result: AnyObject) in
			cell.setProfileImage(result as! String)
		}*/
		
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