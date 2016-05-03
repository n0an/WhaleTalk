//
//  ANNewGroupParticipantsViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 03/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

class ANNewGroupParticipantsViewController: UIViewController {
    
    // MARK: - Attributes

    var context: NSManagedObjectContext?
    var chat: Chat?
    var chatCreationDelegate: ChatCreationDelegate?
    
    private var searchField: UITextField!
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    
    private var displayedContacts = [Contact]()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Participants"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "createChat")
        
        showCreateButton(false)
        
        // !!!IMPORTANT!!!
        // PREVENT OVERLAPPING CONTENT WITH UINAVIGATION CONTROLLER
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        searchField = createSearchField()
        
        tableView.tableHeaderView = searchField
        
        fillViewWith(tableView)
        
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending:  true)]
            
            do {
                if let result = try context.executeFetchRequest(request) as? [Contact] {
                    displayedContacts = result
                }
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
    
    private func createSearchField() -> UITextField {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        searchField.placeholder = "Type contact name"
        
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        searchField.leftView = holderView
        searchField.leftViewMode = .Always
        
        let image = UIImage(named: "contact-icon")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let contactImage = UIImageView(image: image)
        contactImage.tintColor = UIColor.darkGrayColor()
        
        holderView.addSubview(contactImage)
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
            
            contactImage.widthAnchor.constraintEqualToAnchor(holderView.widthAnchor, constant: -20),
            contactImage.heightAnchor.constraintEqualToAnchor(holderView.heightAnchor, constant: -20),
            contactImage.centerXAnchor.constraintEqualToAnchor(holderView.centerXAnchor),
            contactImage.centerYAnchor.constraintEqualToAnchor(holderView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        return searchField
    }
    
    
    private func showCreateButton(show: Bool) {
        if show {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    

}

// MARK: - UITableViewDataSource

extension ANNewGroupParticipantsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let contact = displayedContacts[indexPath.row]
        
        cell.textLabel?.text = contact.fullName
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    
}





















