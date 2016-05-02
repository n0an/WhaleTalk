//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 01/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var messages = [Message]()
    
    private let cellIdentifier = "Cell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        var localIncoming = true
        
        for i in 0...10 {
            let m = Message()
//            m.text = String(i)
            m.text = "This is a longer message."
            
            m.incoming = localIncoming
            localIncoming = !localIncoming
            
            messages.append(m)
        }
        
        tableView.registerClass(ANChatCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ANChatCell
        
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.text
        cell.incoming(message.incoming)
        
        
        // !!!IMPORTANT!!!
        // REMOVE TABLEVIEW SEPARATOR
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        
        return cell
    }
    
}


extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}


























