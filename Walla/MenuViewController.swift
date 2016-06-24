//
//  MenuViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MenuViewController : UIViewController {
	
	@IBAction func closeMenu(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}