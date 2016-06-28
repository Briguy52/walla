//
//  MenuViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

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
		
		add.enabled = false
		clear.enabled = false
		cancel.enabled = false
	}
	
	@IBAction func typingFilter(sender: AnyObject) {
		
	}
	
	@IBAction func addFilter(sender: AnyObject) {
		
	}
	
	@IBAction func clearFilter(sender: AnyObject) {
		
	}
	
	@IBAction func cancelFilter(sender: AnyObject) {
		
	}
	
}