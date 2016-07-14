//
//  MessageViewController.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import Firebase
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController, UINavigationBarDelegate{
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var messageRef: Firebase!
    var usersTypingQuery: FQuery!
    
    // Tells this class to load Messages from /Messages/convoID
    var convoID: String = ""


	@IBOutlet weak var backButton: UIBarButtonItem!
	let myBasic = Basic() // This ref will be replaced by the selected conversation ref
	let myUserBackend = UserBackend()
	let myConvoBackend = ConvoBackend()
	var navBar: UINavigationBar = UINavigationBar()//:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.messageRef = self.myBasic.messageRef.childByAppendingPath(self.convoID)
        
        title = "ChatChat"
        self.setupBubbles()
        
        // No avatars - consider removing
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        observeMessages()
        observeTyping()
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "text": text,
            "sender": senderId,
            "timestamp": self.myBasic.getTimestamp(),
            "recipient":""
        ]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        isTyping = false
    }
    
    
    private func observeMessages() {
        let messagesQuery = messageRef.queryLimitedToLast(25)
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            
            let id = snapshot.value["sender"] as! String
            let text = snapshot.value["text"] as! String
            
            self.addMessage(id, text: text)
            self.finishReceivingMessage()
        }
    }
    
    var userIsTypingRef: Firebase!
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = self.myBasic.rootRef.childByAppendingPath("typingIndicator")
        userIsTypingRef = typingIndicatorRef.childByAppendingPath(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        
        usersTypingQuery.observeEventType(.Value) { (data: FDataSnapshot!) in
            
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }
        
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
	
//	func backButtonClick() -> Void
//	{
//		dismissViewControllerAnimated(true, completion: nil)
//		//self.navigationController?.popViewControllerAnimated(true)
//	}
//	
//	@IBAction func backMessage(sender: UIBarButtonItem) {
//		dismissViewControllerAnimated(true, completion: nil)
//		//self.navigationController?.popViewControllerAnimated(true)
//	}
}