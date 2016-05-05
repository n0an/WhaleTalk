//
//  ANNewChatViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 02/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

class ANNewChatViewController: UIViewController, TableViewFetchedResultsDisplayer {
    
// MARK: - Attributes
    
    var context: NSManagedObjectContext?
    
    private var fetchedResultsController: NSFetchedResultsController?
    
    private let  tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?

    
    var chatCreationDelegate: ChatCreationDelegate?
    
    
// MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Chat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fillViewWith(tableView)
        
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: "NewChatViewController")
            
            fetchedResultsDelegate = ANTableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("There was a problem fetching.")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Helper methods
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        cell.textLabel?.text = contact.fullName
        
    }
    
    
    // MARK: - Actions

    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



// MARK: - UITableViewDataSource

extension ANNewChatViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        
        let currentSection = sections[section]
        return currentSection.numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}

        let currentSection = sections[section]
        
        return currentSection.name
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
}

// MARK: - UITableViewDelegate

extension ANNewChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        
        guard let context = context else {return}
        
        
        let chat = Chat.existing(directWith: contact, inContext: context) ?? Chat.new(directWith: contact, inContext: context)
        
        
        chatCreationDelegate?.created(chat: chat, inContext: context)
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}


























