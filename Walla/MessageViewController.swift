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

class MessageViewController: SLKTextViewController, UINavigationBarDelegate{
	
	@IBOutlet weak var backButton: UIBarButtonItem!
	let myBasic = Basic() // This ref will be replaced by the selected conversation ref
	let myUserBackend = UserBackend()
	let myConvoBackend = ConvoBackend()
	var messageModels : [MessageModel] = [MessageModel]()
	var disposeBag = DisposeBag()
	var isInitialLoad = true;
	var sender = "sender" // TODO: comes from backend
	var recipient = ""
	var convoID = "sampleConversation"
	
	var pressedRightButtonSubject : PublishSubject<String> = PublishSubject()
	
	var navBar: UINavigationBar = UINavigationBar()//:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("womp MessageVC did load")
        
        self.initModel()
        self.initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("womp MessageVC did appear")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("womp MessageVC will appear")
    }
    
    func initModel() {
        self.sender = myBasic.rootRef.authData.uid
        
        let keychain = MyApplication.sharedInstance.keychain
        let profileData:NSData! = keychain.dataForKey("profile")
        let profile:A0UserProfile = NSKeyedUnarchiver.unarchiveObjectWithData(profileData) as! A0UserProfile
        
        self.observeMessages()
    }
    
    func initView() {
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
    }
    
    func observeMessages() {
        
//        self.messageModels.removeAll()
        let refToObserve = self.myBasic.messageRef.childByAppendingPath(self.convoID)
        let secondRef = self.myBasic.messageRef
        
        //part 1
        refToObserve.rx_observe(FEventType.ChildAdded)
            .filter { snapshot in
                return !(snapshot.value is NSNull)
            }
            .map {snapshot in
//                print(snapshot.key)
//                print(snapshot.value)
                return MessageModel(snapshot: snapshot)
            }
            .subscribeNext({ (messageModel: MessageModel) -> Void in
                self.messageModels.insert(messageModel, atIndex: 0);
//                if(self.isInitialLoad == false){
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
//                    self.tableView.endUpdates()
//                    //you can do everything else here!
//                }
            })
            .addDisposableTo(self.disposeBag)
        
        refToObserve.rx_observe(FEventType.Value)
            .subscribeNext({ (snapshot: FDataSnapshot) -> Void in
                print("subscribing again")
                self.tableView.reloadData()
                self.isInitialLoad = false;
                print("flag")
            })
            .addDisposableTo(self.disposeBag)
        
        pressedRightButtonSubject
            .flatMap({ (bodyText: String) -> Observable<Firebase> in
                print("flat mapping")
                let sender = self.sender
                let recipient = self.recipient
                return refToObserve.childByAutoId().rx_setValue(["text": bodyText, "sender": sender, "recipient": recipient, "timestamp" : self.myBasic.getTimestamp()])
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
        print("womp there are " + String(self.messageModels.count) + " rows in section")
//        print(self.messageModels)
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
			(result: AnyObject) in
            cell.nameLabel.text = result as? String
		}
		
        // Safe unwrapping of text
        if let messageText = messageModelAtIndexPath.text as? String {
            cell.bodyLabel.text = messageText
        }
        
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
}