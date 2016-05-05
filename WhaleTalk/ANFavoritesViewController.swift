//
//  ANFavoritesViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 05/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class ANFavoritesViewController: UIViewController, TableViewFetchedResultsDisplayer, ContextViewController {
    
    // MARK: - ATTRIBUTES
    
    var context: NSManagedObjectContext?
    
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "FavoriteCell"
    
    private let store = CNContactStore()
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Favorites"
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(ANFavoriteCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        // !!!TRY_IT!!!
        tableView.dataSource = self
        tableView.delegate = self
        
        fillViewWith(tableView)
        
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            
            request.predicate = NSPredicate(format: "favorite = true")
            
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
    

    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        guard let cell = cell as? ANFavoriteCell else {return}
        
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.status ?? "***no status***"
        
        cell.phoneTypeLabel.text = contact.phoneNumbers?.filter({
            number in
            guard let number = number as? PhoneNumber else {return false}
            return number.registered }).first?.kind
        
//        cell.phoneTypeLabel.text = contact.phoneNumbers?.allObjects.first?.kind
        
        cell.accessoryType = .DetailButton
        
    }
    
    
    

}


// MARK: - UITableViewDataSource

extension ANFavoritesViewController: UITableViewDataSource {
    
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

// MARK: - UITableViewDelegate

extension ANFavoritesViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
    }
    
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        guard let id = contact.contactId else {return}
        
        let cncontact: CNContact
        do {
            cncontact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        
        let vc = CNContactViewController(forContact: cncontact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
}























