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
    
    var isIncoming: Bool {
        return sender != nil
    }
    

}
