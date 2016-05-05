//
//  TableViewFetchedResultsDisplayer.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 05/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewFetchedResultsDisplayer {
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}
