//
//  FirebaseModels.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 06/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase
import CoreData



protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
    
}




extension Contact: FirebaseModel {
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else {return}
        
        
        for number in phoneNumbers {
            rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(number.value).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                guard let user = snapshot.value as? NSDictionary else {return}
                let uid = user.allKeys.first as? String
                
                context.performBlock{
                    self.storageId = uid
                    number.registered = true
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error saving")
                    }
                }
            
            })
            
        }
    }
    
}




extension Chat: FirebaseModel {
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard storageId == nil else {return}
        
        
        let ref = rootRef.childByAppendingPath("chats").childByAutoId()
        
        storageId = ref.key
        
        var data: [String: AnyObject] = [
        
        "id": ref.key,
        
        ]
        
        guard let participants = participants?.allObjects as? [Contact] else {return}
        
        var numbers = [FireBaseStore.currentPhoneNumber!: true]
        var userIds = [rootRef.authData.uid]
        
        for participant in participants {
            guard let phoneNumbers = participant.phoneNumbers?.allObjects as? [PhoneNumber] else {continue}
            
            guard let number = phoneNumbers.filter({$0.registered}).first else {continue}
            
            numbers[number.value!] = true
            userIds.append(participant.storageId!)
        }
        
        data["participants"] = numbers
        
        if let name = name {
            data["name"] = name
        }
        
        ref.setValue(["meta": data])
        
        for id in userIds {
            rootRef.childByAppendingPath("users/"+id+"/chats/"+ref.key).setValue(true)
        }
        
        
    }
    
    
}












