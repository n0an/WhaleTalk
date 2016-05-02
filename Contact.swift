//
//  Contact.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

    var sortLetter: String {
        let letter = lastName?.characters.first ?? firstName?.characters.first
        let s = String(letter!)
        return s
    }
    
    var fullName: String {
        
        var fullName = ""
        
        if let firstName = firstName {
            fullName += firstName
        }
        
        if let lastName = lastName {
            if fullName.characters.count > 0 {
                fullName += " "
            }
            fullName += lastName
        }
        
        return fullName
        
    }

}
