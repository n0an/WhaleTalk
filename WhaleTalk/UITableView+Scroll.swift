//
//  UITableView+Scroll.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import UIKit


// !!!IMPORTANT!!!
// SCROLL TO BOTTOM TABLEVIEW

extension UITableView {
    func scrollToBottom() {
        
        if numberOfRowsInSection(0) > 0 {
            
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
            
        }
        
        
    }
}

