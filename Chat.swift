//
//  Chat.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


class Chat: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var lastMessage:Message? {
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "chat = %@", self)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        
        do {
            guard let results = try self.managedObjectContext?.executeFetchRequest(request) as? [Message] else {return nil}
            return results.first
        } catch {
            print("Error for Request")
        }
        
        return nil
        
    }
    
    
    
    // !!!IMPORTANT!!!
    func add(participant contact: Contact) {
        mutableSetValueForKey("participants").addObject(contact)
        
        
    }
    
    
    
}
