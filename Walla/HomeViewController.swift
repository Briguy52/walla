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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var noWallas: UILabel!
	
	var cellIdentifier = "ViewWallaCell"
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
    let myRequestBackend = RequestBackend()
	let postPath = "posts"
	let tagPath = "tags"
	let postContents = ["title", "content", "authorID", "latitude", "longitude", "urgency", "tags", "expirationDate"]
	var isInitialLoad = true;
	var disposeBag = DisposeBag()
	var authorName = ""
	var latitude = ""
	var longitude = ""
	var currentTime = NSDate().timeIntervalSince1970
    
    // TODO: stores these tags in the Users ref
    var tagsToFilter: [String] = ["#STEM+ "]
	
//	var usernames: [String] = ["user1", "user2", "user3", "user4"]
//	var messages: [String] = ["m1", "m2", "m3", "m4"]
//	var topics: [String] = ["t1", "t2", "t3"]
	
	func ViewDidLoad()
	{
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		masterView = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backgroundImage = UIImage(named: "background")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView?.backgroundView = imageView
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		
		imageView.contentMode = .ScaleAspectFill
		
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
        
        // Ask Tim about the order of WHEN to place this call
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
    
    // Copied from MessagingVC, remainder of code to use is there
    func observeWithStreams() {
        requestModels.removeAll()
        self.myBasic.requestRef.rx_observe(FEventType.ChildAdded)
            .filter { snapshot in
                return !(snapshot.value is NSNull) // hide Null requests
            }
            .filter { snapshot in
                if let exp = snapshot.value.objectForKey("expirationDate")?.doubleValue { // hide expired Requests
                    return exp >= self.currentTime
                }
                return false
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
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell :HomeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! HomeCell
		
		let requestModel = requestModels[indexPath.row]
		
		let key = requestModel.authorID
		self.myUserBackend.getUserInfo("displayName", userID: key)
		{
			(result: AnyObject) in
            cell.setAuthorName(result as! String)
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