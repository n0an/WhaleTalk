//
//  ANNewGroupViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 03/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

class ANNewGroupViewController: UIViewController {

    var context: NSManagedObjectContext?
    var chatCreationDelegate: ChatCreationDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Group"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
