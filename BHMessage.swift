//
//  BHMessage.swift
//  Messaging
//
//  Created by Brian Heller on 4/1/16.
//  Copyright © 2016 Brian Heller. All rights reserved.
//

import UIKit

class BHMessage: NSObject {
    var body:String!
    var sender_id:String!
    var display_name:String!
    var sent_at:NSDate!
    
    init(body:String, sender_id:String, sent_at:NSDate, display_name:String) {
        self.body = body
        self.sender_id = sender_id
        self.sent_at = sent_at
        self.display_name = display_name
    }
}
