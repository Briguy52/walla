//
//  MenuViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

var hasFilters: Bool = false
var filterTags: [String] = ["All", "Comp Sci", "Math", "Engineering", "Pre Med", "Physics", "Biology", "Chemistry", "Global Health", "Sports", "Video Games", "Music", "Dance", "English", "Business", "Engineering", "Marketing", "Finance"]

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
    let myRequestBackend = RequestBackend()
    let myConvoBackend = ConvoBackend()
	
	var cellIdentifier = "TopicTagName"
	
	@IBOutlet weak var tableView: UITableView!
	
	@IBAction func closeMenu(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView?.tableFooterView = UIView(frame: CGRectZero)
		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
        
//        self.myConvoBackend.reloadConvoModels()
//        self.myRequestBackend.populateFilter()
	}
	
//	override func viewWillAppear(animated: Bool) {
//		viewWillAppear(animated)
//		tableView?.tableFooterView = UIView(frame: CGRectZero)
//		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
//	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filterTags.count
 	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell :FilterCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FilterCell
		
		let title = filterTags[indexPath.row]
		
		cell.topicTitle?.text = title
		
		return cell
	}

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tagsToFilter.removeAll()
        tagsToFilter.append(filterTags[indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}

}