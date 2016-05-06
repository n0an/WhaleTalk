//
//  RemoteStore.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 06/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


protocol RemoteStore {
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: ()->(), error:(errorMessage: String)->())
    
    
    func startSyncing()
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
}


