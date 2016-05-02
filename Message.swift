//
//  Message.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

    // !!!IMPORTANT!!!
    // CONVERSION FROM COREDATA'S NSNUMBER TO BOOL
    
    var isIncoming: Bool {
        get {
            guard let incoming = incoming else {return false}
            return incoming.boolValue
        }
        
        set (incoming) {
            self.incoming = incoming
        }
    }
    

}
