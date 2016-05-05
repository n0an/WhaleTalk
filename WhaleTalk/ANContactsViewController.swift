//
//  ANContactsViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 04/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI
import Contacts

class ANContactsViewController: UIViewController, ContextViewController, TableViewFetchedResultsDisplayer {
    
    // MARK: - ATTRIBUTES
    
    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?

    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "All Contacts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: "newContact")
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        
        fillViewWith(tableView)
        
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            
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
    
    // MARK: - HELPER METHODS
    
    func newContact() {
        
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        cell.textLabel?.text = contact.fullName
    }
    
    
}



extension ANContactsViewController: UITableViewDataSource {
    
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
    
    
}
























