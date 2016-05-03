//
//  ContactImporter.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 03/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreData
import Contacts

class ContactImporter {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
    
        self.context = context
        
    }
    
    
    func fetch() {
        
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts, completionHandler: { (granted, error) in
            
            if granted {
                do {
                    let req = CNContactFetchRequest(keysToFetch:
                        [CNContactGivenNameKey,
                            CNContactFamilyNameKey,
                            CNContactPhoneNumbersKey])
                    
                    try store.enumerateContactsWithFetchRequest(req, usingBlock: { (cnContact, stop) in
                        print(cnContact)
                        
                        guard let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: self.context) as? Contact else {return}
                        
                        contact.firstName = cnContact.givenName
                        contact.lastName = cnContact.familyName
                        contact.contactId = cnContact.identifier
                        
                        print(contact)
                    })
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                } catch {
                    print("Error with do-catch")
                }
            }
            
        })
        
    }
}






