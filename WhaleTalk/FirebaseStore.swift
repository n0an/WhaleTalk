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
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func hasAuth()-> Bool {
        return rootRef.authData != nil
    }
    
}



