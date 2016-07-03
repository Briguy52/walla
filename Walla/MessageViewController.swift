//
//  MessageViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import Lock
import RxCocoa
import RxSwift
import SlackTextViewController
import FirebaseRxSwiftExtensions
import Firebase

class MessageViewController: SLKTextViewController, UINavigationBarDelegate {
	
	@IBOutlet weak var backButton: UIBarButtonItem!
	let myBasic = Basic() // This ref will be replaced by the selected conversation ref
	let myUserBackend = UserBackend()
	let myConvoBackend = ConvoBackend()
	var messageModels : [MessageModel] = [MessageModel]()
	var disposeBag = DisposeBag()
	var isInitialLoad = true;
	var sender = "sender" // TODO: comes from backend
	var recipient = "recipient" // TODO: comes from backend
	var convoID = "sampleConversation"
	
	var pressedRightButtonSubject : PublishSubject<String> = PublishSubject()
	
	var navBar: UINavigationBar = UINavigationBar()//:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sender = myBasic.rootRef.authData.uid
		
		let keychain = MyApplication.sharedInstance.keychain
		let profileData:NSData! = keychain.dataForKey("profile")
		let profile:A0UserProfile = NSKeyedUnarchiver.unarchiveObjectWithData(profileData) as! A0UserProfile
		
		self.bounces = true
		self.shakeToClearEnabled = true
		self.keyboardPanningEnabled = true
		self.typingIndicatorView.canResignByTouch = true
		self.textInputbar.autoHideRightButton = true
		self.textInputbar.maxCharCount = 140
		self.textInputbar.counterStyle = SLKCounterStyle.Split
		self.inverted = true
		
		tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.REUSE_ID)
		tableView.rowHeight = UITableViewAutomaticDimension //needed for autolayout
		tableView.estimatedRowHeight = 50.0 //needed for autolayout
		
		tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 44, tableView.frame.size.width, tableView.contentSize.height)
		
		// navBar: UINavigationBar = UINavigationBar(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
		
		navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
		navBar.backgroundColor = UIColor.init(netHex: 0xffa160)
		navBar.delegate = self
		let navItem = UINavigationItem()
		navItem.title = "Messaging"
		//		let backButton = UIButton(type: .Custom)
		//		backButton.setTitle("Back", forState: .Normal)
		//		backButton.setTitleColor(backButton.tintColor, forState: .Normal)
		//		backButton.addTarget(self, action: "backButtonClick", forControlEvents: .TouchUpInside)
		//		navItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
		
		let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonClick")
		navItem.leftBarButtonItem = backButton
		
		navBar.items = [navItem]
		self.view.addSubview(navBar)
		
		
		// Messages ref stores the Messages for a Conversation
		let conversationRef = myBasic.messageRef.childByAppendingPath(self.convoID)
		
		//part 1
		conversationRef.rx_observe(FEventType.ChildAdded)
			.filter { snapshot in
				return !(snapshot.value is NSNull)
			}
			.map {snapshot in
				return MessageModel(snapshot: snapshot)
			}
			.subscribeNext({ (messageModel: MessageModel) -> Void in
				self.messageModels.insert(messageModel, atIndex: 0);
				if(self.isInitialLoad == false){
					self.tableView.beginUpdates()
					self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
					self.tableView.endUpdates()
					//you can do everything else here!
				}
			})
			.addDisposableTo(self.disposeBag)
		
		conversationRef.rx_observe(FEventType.Value)
			.subscribeNext({ (snapshot: FDataSnapshot) -> Void in
				self.tableView.reloadData()
				self.isInitialLoad = false;
			})
			.addDisposableTo(self.disposeBag)
		
		pressedRightButtonSubject
			.flatMap({ (bodyText: String) -> Observable<Firebase> in
				let sender = self.sender
				let recipient = self.recipient
				return conversationRef.childByAutoId().rx_setValue(["text": bodyText, "sender": sender, "recipient": recipient, "timestamp" : NSDate().timeIntervalSince1970 * 1000])
			})
			.subscribeNext({ (newMessageReference:Firebase) -> Void in
				print("A new message was successfully committed to firebase")
			})
			.addDisposableTo(self.disposeBag)
	}
	
	override func didPressRightButton(sender: AnyObject!) {
		pressedRightButtonSubject.onNext(self.textView.text)
		super.didPressRightButton(sender) // this important. calling the super.didPressRightButton will clear the method. We cannot use rx_tap due to inheritance
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messageModels.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.REUSE_ID, forIndexPath: indexPath) as! MessageTableViewCell
		
		let messageModelAtIndexPath = messageModels[indexPath.row]
		
		//        self.tableView.scrollToRowAtIndexPath((indexPath, atScrollPosition: .Bottom,
		//            animated: true))
		
		let key = messageModelAtIndexPath.sender
		self.myUserBackend.getUserInfo("displayName", userID: key)
		{
			(result: AnyObject)
			in cell.nameLabel.text = result as! String
		}
		
		cell.bodyLabel.text = messageModelAtIndexPath.text
		cell.selectionStyle = .None
		cell.transform = self.tableView.transform // TODO: figure out what this actually does
		return cell
	}
	
	func backButtonClick() -> Void
	{
		dismissViewControllerAnimated(true, completion: nil)
		//self.navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func backMessage(sender: UIBarButtonItem) {
		dismissViewControllerAnimated(true, completion: nil)
		//self.navigationController?.popViewControllerAnimated(true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}