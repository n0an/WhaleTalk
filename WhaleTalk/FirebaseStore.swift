//
//  FirebaseStore.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 06/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase
import CoreData


class FireBaseStore {
    
    private let context: NSManagedObjectContext
    private let rootRef = Firebase(url: "https://noanwhaletalk.firebaseio.com")
    
    private(set) static var currentPhoneNumber: String? {
        set(phoneNumber) {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func hasAuth()-> Bool {
        return rootRef.authData != nil
    }
    
    private func upload(model: NSManagedObject) {
        guard let model = model as? FirebaseModel else {return}
        
        model.upload(rootRef, context: context)
        
        
    }
    
}


extension FireBaseStore: RemoteStore {
    
    func startSyncing() {
        
    }
    
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        
        inserted.forEach(upload)
        
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
        
    }
    
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: () -> (), error errorCallback: (errorMessage: String) -> ()) {
        
        rootRef.createUser(email, password: password, withValueCompletionBlock: {
            error, result in
            
            if error != nil {
                errorCallback(errorMessage: error.description)
            } else {
                let newUser = [
                    "phoneNumber" : phoneNumber
                ]
                FireBaseStore.currentPhoneNumber = phoneNumber
                let uid = result["uid"] as! String
                self.rootRef.childByAppendingPath("users").childByAppendingPath(uid).setValue(newUser)
                
                self.rootRef.authUser(email, password: password, withCompletionBlock: {
                error, authData in
                    if error != nil {
                        errorCallback(errorMessage: error.description)
                    } else {
                        success()
                    }
                
                })
                
            }
            
        })
        
    }
    
    
}











