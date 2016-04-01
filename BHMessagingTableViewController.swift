//
//  BHMessagingTableViewController.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHMessagingTableViewController: UITableViewController {
    
    var conversations:NSArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Start by creating an instance of BHConversationBuilder
        let builder = BHConversationBuilder()
        // We will set the delegate as self so the builder knows which object to return the data to.
        // The actual implementation of the delegate methods are below in the first extension.
        builder.delegate = self
        // Now we start the request and if all goes well it will retrieve the data and update the table view.
        // As of right now since this is just an example, I'm using some seeded data on the localhost server.
        builder.getUserConversations("10101812792890508")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // We only want one section in the table.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is where we will set the value equal to conversations.count -- this will ensure we have
        // one cell for each of the conversatios in store
        return conversations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! BHMessagingTableViewCell

        // Configure the cell...  Ideally we will abstract this into another function to return all the data
        // contained in the cell.  That's a project for another day, though.
        // Set the image.  The URI for the image is stored in the displayImageUrl variable of the conversation.
        // We can use that to get the data and then display it on the tableview
        let conversation = conversations.objectAtIndex(indexPath.row) as! BHConversation
        let image = UIImage(data: NSData(contentsOfURL: NSURL(string: conversation.displayImageUrl)!)!)
        cell.profileImageView.image = image
        // The following two variables will make the image round and clip anything that appears outside the circle
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height / 2
        cell.clipsToBounds = true
        
        // Now we can set the last sent message.
        let last_message = conversation.lastMessage
        // We can add the "You:" to the beginning like facebook messager by checking the sender_id of the last
        // message to our ID.
        if last_message.sender_id == "10101812792890508" {
            cell.lastMessage.text = "You: \(last_message.body)"
        }
        else {
            cell.lastMessage.text = last_message.body
        }
        // We will also use the Facebook Graph API to get the name of the individual that we are sending the message
        // too, but thats too much of a pain in the ass to setup for a sample app so we will cross that bridge
        // when we come to it.  For now all we have left is to set the sent at timestamp.  Again, we will use a date
        // formatter for this.  For a list of date format variables 
        // go here http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:ma"
        // Use the date formatter to set the timeStamp label to the time the message was sent at
        cell.timeStamp.text = dateFormatter.stringFromDate(last_message.sent_at)
        return cell
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

/*
 Here is where we will handle the delegate method.  We will perform the request and when it is finished, update the array and
*/
// MARK: -BHConversationBuilderDelegate
extension BHMessagingTableViewController : BHConversationBuilderDelegate {
    func didFinishRetrievingMessages(messages: NSMutableArray) {
        // the request is finished and this will now be called.  We need to set the conversations array as the messages
        // returned from this function and reload the tableview
        self.conversations = messages
        print(messages.count)
        print(self.conversations.count)
        self.tableView.reloadData()
    }
}
