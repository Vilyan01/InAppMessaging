//
//  BHConversationBuilder.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHConversationBuilder: NSObject {
    
    /*
    Get's a conversation from the server based on the user ID.  It's static so no object will need to be created.  You just call it as some_array = BHConversationBuilder.getUserConversations("124124124") or whatever the user ID You want conversations for is and it will return a formatted array of all conversations
     */
    static func getUserConversations(user_id:String) -> NSMutableArray {
        // initialize empty array
        let arr = NSMutableArray()
        // boolean variable used for blocking since synchronous responses are frowned upon 
        // but we NEED the data before continuing.  There may be a more graceful way to handle
        // this but in the mean time we can just use this
        var done = false
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
                        let lender_id:String = conv.valueForKey("lender_id") as! String
                        let borrower_id:String = conv.valueForKey("borrower_id") as! String
                    }
                    
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
            // Set that done variable to true so that it can continue on with it's functionality.
            done = true
        })
        // This is what starts the task.  It may seem kind of out of order, but once you get the hang
        // of how completion handlers work it will make more sense.
        task.resume()
        // This will cause the function to just continuously do nothing on the main thread while the request
        // is being handled.
        while (!done) {
        }
        // Finally, return the array of conversations to be passed to the TableViewController
        return arr
    }
}
