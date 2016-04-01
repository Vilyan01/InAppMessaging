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

        // Configure the cell...

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
        //self.conversations = messages
        print(messages.count)
        self.tableView.reloadData()
    }
}
