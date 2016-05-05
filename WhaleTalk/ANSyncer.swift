//
//  ANSyncer.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 05/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

class ANSyncer: NSObject {

    private var mainContext: NSManagedObjectContext
    private var backgroundContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mainContextSaved:", name: NSManagedObjectContextDidSaveNotification, object: mainContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backgroundContextSaved:", name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
        
    }
    
    func mainContextSaved(notification: NSNotification) {
        
        backgroundContext.performBlock { 
            self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
        }
        
    }
    
    func backgroundContextSaved(notification: NSNotification) {
        
        mainContext.performBlock { 
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
    
    
}









