//
//  MyTopics.swift
//  Walla
//
//  Created by Timothy Choh on 6/30/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class MyTopics: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
	
	@IBOutlet weak var topicPicker: UIPickerView!
	@IBOutlet weak var addTopics: UIButton!
	@IBOutlet weak var clearTopics: UIButton!
	@IBOutlet weak var topicLabel: UILabel!
	
	let myBasic = Basic()
	let myUserBackend = UserBackend()
    
    // TODO: replace with call to Backend store of Tags
    var myTags: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

        self.checkForTags()
        
        // In order to show the Tag Picker
        self.topicPicker?.dataSource = self
        self.topicPicker?.delegate = self

		self.tabBarController?.tabBar.hidden = true
	}
    
    func checkForTags() {
        let refToTry = self.myBasic.userRef.child(self.myUserBackend.getUserID())
    
        refToTry.observeEventType(.Value, withBlock: { snapshot in
            // Confirm that User has preset tags
            if snapshot.value!.objectForKey("tags") != nil {
                self.initTags(snapshot.value!.objectForKey("tags") as! [String])
            }
        })
    }
    
    func initTags(tags: [String]) {
        for tag in tags {
            self.addTag(tag)
        }
    }
    
    func isValid() -> Bool {
//        if topicLabel.text!.isEmptyField == false
        return !self.myTags.isEmpty
    }
	
	@IBAction func goBack(sender: UIBarButtonItem) {
		let alert = UIAlertView()
		alert.title = "You Need Topics!"
		alert.message = "You need at minimum\n one topic!"
		alert.addButtonWithTitle("OK")
		
        if !self.isValid() {
            alert.show()
        }
		else {
			self.tabBarController?.tabBar.hidden = false
			dismissViewControllerAnimated(true, completion: nil)
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
		self.topicLabel.textColor = UIColor.redColor()
		self.topicLabel.text = "Please Enter a Tag"
        self.updateUserTags()
	}
	
	func addTag(tag: String) {
        if (!self.myTags.contains(tag)) {
            self.myTags.append(tag)
            self.topicLabel.text = self.myTags.joinWithSeparator("\n")
        }
        self.updateUserTags()
	}
    
    func updateUserTags() {
        self.myUserBackend.updateUserData("tags", value: self.myTags, userID: self.myUserBackend.getUserID())
    }
}