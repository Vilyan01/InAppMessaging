//
//  MessageViewController.swift
//  Messaging
//
//  Created by Brian Heller on 4/2/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var convId:NSNumber!
    
    // Sets the message bubble colors
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 101/255, green: 7/255, blue: 113/255, alpha: 1.0))
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())


    override func viewDidLoad() {
        super.viewDidLoad()
        print("convId: \(convId)")
        // Remove all the avatars from the sides of messages
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        // Set the title of the view controller to the senderId
        self.title = self.senderId
        
        // Create a ConversationBuilder to grab a conversation from.
        if convId != nil {
            let convBuilder = BHConversationBuilder()
            convBuilder.delegate = self
            convBuilder.getIndividualConversation(self.convId!)
            print("Conversation ID: \(self.convId!)")
        }
        else {
            print("Error: UserId is not set.  Can't pull conversation data without a userId!")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Enable springy bubbles
        self.collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    // This function is also needed to disable avatars at the side of messages.
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // This will set the number of items in the collection view!
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // This sets the data for the cell
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let msg = self.messages[indexPath.row]
        return msg
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        }
        else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.row]
        if(message.senderId != self.senderId) {
            cell.textView!.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let msg = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(msg)
        self.finishSendingMessage()
        
        // Save to the database!
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
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

// MARK: - BHConversationBuilderDelegate
extension MessageViewController : BHConversationBuilderDelegate {
    func didFinishRetrievingIndividualConversation(conversation: NSMutableArray) {
        // Create a JSQMessage from the BHMessages stored in the conversation variable
        for i in 0...conversation.count-1 {
            let msg = conversation.objectAtIndex(i) as! BHMessage
            let jsMsg = JSQMessage(senderId: msg.sender_id, senderDisplayName: msg.display_name, date: msg.sent_at, text: msg.body)
            messages.append(jsMsg)
        }
        // Done, reload data
        self.collectionView.reloadData()
    }
}
