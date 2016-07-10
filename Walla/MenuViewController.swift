//
//  MenuViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

var hasFilters: Bool = false

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
    let myConvoBackend = ConvoBackend()
	
	var filterTags: [String] = ["All", "Time"]
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
        
        self.myConvoBackend.reloadConvoModels()
        self.populateFilter()
	}
	
//	override func viewWillAppear(animated: Bool) {
//		viewWillAppear(animated)
//		tableView?.tableFooterView = UIView(frame: CGRectZero)
//		tableView?.backgroundColor = UIColor(netHex: 0xffa160)
//	}
	
    // Based on logic in MyTopic.swift
	func populateFilter() {
        let refToTry = self.myBasic.userRef.childByAppendingPath(self.myUserBackend.getUserID())
        
        refToTry.observeEventType(.Value, withBlock: { snapshot in
            // Confirm that User has preset tags
            if snapshot.value.objectForKey("tags") != nil {
                if let tagsToAppend = snapshot.value.objectForKey("tags") as? [String] {
                    for index in 0..<tagsToAppend.count {
                        if !self.filterTags.contains(tagsToAppend[index]) {
                            self.filterTags.append(tagsToAppend[index])
                        }
                    }
                }
            }
        })
	}
	
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
        tagsToFilter.append(self.filterTags[indexPath.row])
        print("chose tag " + self.filterTags[indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}

}