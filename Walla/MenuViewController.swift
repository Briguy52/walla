//
//  MenuViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

var hasFilters: Bool = false

class MenuViewController : UIViewController {
	
	@IBOutlet weak var type: UITextField!
	@IBOutlet weak var filters: UILabel!
	@IBOutlet weak var add: UIButton!
	@IBOutlet weak var clear: UIButton!
	@IBOutlet weak var cancel: UIButton!
	
	@IBAction func closeMenu(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.add.enabled = false
		self.clear.enabled = false
		self.cancel.enabled = false
	}
	
	@IBAction func typingFilter(sender: AnyObject) {
		self.add.enabled = true
	}
	
	@IBAction func addFilter(sender: AnyObject) {
		let i = 1
		let doesMatch: String = self.type.text!
		
		repeat {
			if tagsToPick[i].containsString(doesMatch) {
				tagsToFilter.append(tagsToPick[i])
				hasFilters = true
				break
			}
		} while i < tagsToPick.count
	}
	
	@IBAction func clearFilter(sender: AnyObject) {
		tagsToFilter.removeAll()
		hasFilters = false
	}
	
	@IBAction func cancelFilter(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
}