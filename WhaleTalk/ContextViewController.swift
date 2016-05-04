//
//  ContextViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 04/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


protocol ContextViewController {
    
    var context: NSManagedObjectContext?{get set}
    
    
}
