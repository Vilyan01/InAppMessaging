//
//  BHConversation.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHConversation: NSObject {
    var conversation_id:NSNumber!
    var lender_id:String!
    var borrower_id:String!
    var displayImageUrl:String!
    var user_id:String!
    var lastMessage:BHMessage!
    
    init(lender_id:String, borrower_id:String, user_id:String, conversation_id:NSNumber) {
        // set required variables
        self.lender_id = lender_id
        self.borrower_id = borrower_id
        self.user_id = user_id
        self.conversation_id = conversation_id
        
        // Set displayImageUrl to whichever one is NOT us.
        if user_id == lender_id {
            // use the borrower ID to get the image
            self.displayImageUrl = "https://graph.facebook.com/\(borrower_id)/picture?width=120&height=120"
        }
        else {
            // Use the lender ID
            self.displayImageUrl = "https://graph.facebook.com/\(lender_id)/picture?width=120&height=120"
        }
    }
}
