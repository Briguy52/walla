//
//  MyTopics.swift
//  Walla
//
//  Created by Timothy Choh on 6/30/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MyTopics: UIViewController
{
	
	@IBOutlet weak var topicPicker: UIPickerView!
	@IBOutlet weak var addTopics: UIButton!
	@IBOutlet weak var clearTopics: UIButton!
	@IBOutlet weak var topicLabel: UILabel!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarController?.tabBar.hidden = true
	}
	
	@IBAction func goBack(sender: UIBarButtonItem)
	{
		let alert = UIAlertView()
		alert.title = "You Need Topics!"
		alert.message = "You need at minimum\n one topic!"
		alert.addButtonWithTitle("OK")
		
		if topicLabel.text!.isEmptyField == false
		{
			alert.show()
		}
		else
		{
			self.tabBarController?.tabBar.hidden = false
			tabBarController?.selectedIndex = 3
		}
	}
	
	//tag functions
	func setPossibleTags(tags: [String]) {
		tagsToPick = tags
	}
	
	func setSelectedTags(tags: [String]) {
		self.myTags = tags
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return tagsToPick.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return tagsToPick[row]
	}
	
	func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let titleData = tagsToPick[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
		
		return myTitle
	}
	
	@IBAction func addTags(sender: UIButton)
	{
		let tag = tagsToPick[self.topicPicker.selectedRowInComponent(0)]
		if topicLabel.text == "Please Enter a Tag"
		{
			topicLabel.text = ""
		}
		self.addTag(tag)
	}
	
	@IBAction func removeTags(sender: UIButton)
	{
		self.myTags.removeAll()
		self.topiclable.textColor = UIColor.redColor()
		self.topicLabel.text = "Please Enter a Tag"
	}
	
	func addTag(tag: String) {
		self.myTags.removeAll()
		self.myTags.append(tag)
		self.topicLabel.text = self.myTags.joinWithSeparator("# ") + "\n"
	}
}