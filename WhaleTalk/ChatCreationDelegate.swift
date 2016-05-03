//
//  ChatCreationDelegate.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 03/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


protocol ChatCreationDelegate {
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
}

