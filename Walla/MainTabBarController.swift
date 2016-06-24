//
//  MainTabBarController.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
//		let controller1 = HomeViewController()
//		let nav1 = UINavigationController(rootViewController: controller1)
//		let customTabBarItem1:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home_32.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "home_32.png"))
//		controller1.tabBarItem = customTabBarItem1
//		
//		let controller2 = ProfileViewController()
//		let nav2 = UINavigationController(rootViewController: controller2)
//		let customTabBarItem2:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "me_32.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "me_32.png"))
//		controller2.tabBarItem = customTabBarItem2
//		
//		let controller3 = WriteMessage()
//		let nav3 = UINavigationController(rootViewController: controller3)
//		
//		let controller4 = UIViewController()
//		let nav4 = UINavigationController(rootViewController: controller4)
//		let customTabBarItem4:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "messages_32.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "messages_32.png"))
//		controller4.tabBarItem = customTabBarItem4
//		
//		let controller5 = LookAround()
//		let nav5 = UINavigationController(rootViewController: controller5)
//		let customTabBarItem5:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "lookaround_32.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "lookaround_32.png"))
//		controller5.tabBarItem = customTabBarItem5
//		
//		
//		self.viewControllers = [nav1, nav2, nav3, nav4, nav5]
//		self.setupMiddleButton()
//	}
//	
//	func setupMiddleButton() {
//		let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
//		var menuButtonFrame = menuButton.frame
//		menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height
//		menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
//		menuButton.frame = menuButtonFrame
//		
//		menuButton.backgroundColor = UIColor.whiteColor()
//		menuButton.layer.cornerRadius = menuButtonFrame.height/2
//		self.view.addSubview(menuButton)
//		
//		menuButton.setImage(UIImage(named: "write_selected_32.png"), forState: UIControlState.Normal)
//		menuButton.addTarget(self, action: #selector(MainTabBarController.menuButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//		
//		self.view.layoutIfNeeded()
//	}
//	
//	func menuButtonAction(sender: UIButton) {
//		self.selectedIndex = 2
//	}
	
}