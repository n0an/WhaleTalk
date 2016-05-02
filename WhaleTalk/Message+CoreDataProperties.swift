//
//  Message+CoreDataProperties.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var incoming: NSNumber?
    @NSManaged var text: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var chat: Chat?

}
