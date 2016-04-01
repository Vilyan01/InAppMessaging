//
//  BHConversationBuilder.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHConversationBuilder: NSObject {
    static func getUserConversations(user_id:String) -> NSMutableArray {
        let arr = NSMutableArray()
        var done = false
        // get conversations
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(NSURL(string: "\(GET_CONVERSATION_URL)/\(user_id)")!, completionHandler: { (data, resp, err) in
            if err != nil {
                print("Error with request: \(err?.localizedDescription)")
                return
            }
            let response = resp as! NSHTTPURLResponse
            if response.statusCode == 200 {
                do {
                    let convs = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as! NSArray
                    
                }
                catch let error as NSError {
                    print("Error building Conversation Object: \(error.localizedDescription)")
                }
            }
            else {
                print("Incorrect status code: \(response.statusCode)")
            }
            done = true
        })
        task.resume()
        // block until done
        while (!done) {
        }
        return arr
    }
}
