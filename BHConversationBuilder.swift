//
//  BHConversationBuilder.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHConversationBuilder: NSObject {
    
    var delegate:BHConversationBuilderDelegate!
    
    /*
    Get's a conversation from the server based on the user ID.  You call this function on an instance and when it gets the required information it will display it will call the delegate function passing the information back to it's delegate
     */
    func getUserConversations(user_id:String) {
        // initialize empty array
        let arr = NSMutableArray()
        // The session is used to communicate between the app and the server using HTTP Requests
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        // Creates a task using the session using a URL from the Strings.swift file (which will not be included in the future
        // once we implement more security because it will contain secrets.  The completion handler is an anonymous function
        // that is called when the app gets a response from the server.
        let task = session.dataTaskWithURL(NSURL(string: "\(GET_CONVERSATION_URL)/\(user_id)")!, completionHandler: { (data, resp, err) in
            // Always check for errors!  In this case if theres an error I print the error's description and return to prevent
            // the app from going any further
            if err != nil {
                print("Error with request: \(err?.localizedDescription)")
                return
            }
            // Convert NSHTTPResponse to NSHTTPURLResponse because NSHTTPResponses don't have status codes which
            // are returned from the server to let you know whether or not the request was valid or not.
            let response = resp as! NSHTTPURLResponse
            // Check to see if the server responded with the OK status code to make sure everything worked out.
            if response.statusCode == 200 {
                // So far everything is fine, now to convert the JSON data into a BHConversation object.
                do {
                    let convs = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as! NSArray
                    // Loop through the conversations and create a BHConversation object out of each of the conversations
                    // that we can pass to the TableViewController to display
                    for conv in convs {
                        let conversation_id:String = String(conv.valueForKey("id"))
                        let lender_id:String = conv.valueForKey("lender_id") as! String
                        let borrower_id:String = conv.valueForKey("borrower_id") as! String
                        let msg = conv.valueForKey("last_message") as! NSDictionary
                        let msg_body = msg.valueForKey("body") as! String
                        let msg_sender_id = msg.valueForKey("sender_id") as! String
                        let msg_sent_at_string = msg.valueForKey("created_at") as! String
                        // We need to convert the date from a ruby date to a NSDate.  For that we will use NSDateFormatter
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZ"
                        // We can now use this formatter to convert the date from a string to an NSDate
                        let msg_sent_at = dateFormatter.dateFromString(msg_sent_at_string)
                        // now that we have all the data returned from our response we can create the object
                        // instance and save it to the array
                        let last_message = BHMessage(body: msg_body, sender_id: msg_sender_id, sent_at: msg_sent_at!)
                        let conversation = BHConversation(lender_id: lender_id, borrower_id: borrower_id, user_id: user_id, conversation_id: conversation_id)
                        conversation.lastMessage = last_message
                        // add it to the array
                        arr.addObject(conversation)
                    }
                    // Now that it's finished, we can send it back to the parent view controller via the delegate method.
                    self.delegate.didFinishRetrievingMessages(arr)
                }
                // catch any errors thrown by the try block up above and print them out.
                catch let error as NSError {
                    print("Error building Conversation Object: \(error.localizedDescription)")
                }
            }
            else {
                // This will be called if the server responded with anything but the OK status.  This can later
                // be used to debug using the server's logs to find where the request went wrong.
                print("Incorrect status code: \(response.statusCode)")
            }
        })
        // This is what starts the task.  It may seem kind of out of order, but once you get the hang
        // of how completion handlers work it will make more sense.
        task.resume()
    }
}

protocol BHConversationBuilderDelegate {
    func didFinishRetrievingMessages(messages:NSMutableArray)
}
