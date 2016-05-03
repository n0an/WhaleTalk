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
    
    // MARK: - ATTRIBUTES

    var context: NSManagedObjectContext?
    var chatCreationDelegate: ChatCreationDelegate?
    
    private let subjectField = UITextField()
    private let characterNumberLabel = UILabel()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Group"
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "next")
        updateNextButton(forCharCount: 0)
        
        subjectField.placeholder = "Group Subject"
        subjectField.delegate = self
        
        subjectField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subjectField)
        updateCharacterLabel(forCharCount: 0)
        
        characterNumberLabel.textColor = UIColor.grayColor()
        characterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectField.addSubview(characterNumberLabel)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGrayColor()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        subjectField.addSubview(bottomBorder)
        
        
        let constraints: [NSLayoutConstraint] = [
        
            subjectField.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 20),
            subjectField.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor),
            subjectField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            
            bottomBorder.widthAnchor.constraintEqualToAnchor(subjectField.widthAnchor),
            bottomBorder.bottomAnchor.constraintEqualToAnchor(subjectField.bottomAnchor),
            bottomBorder.leadingAnchor.constraintEqualToAnchor(subjectField.leadingAnchor),
            bottomBorder.heightAnchor.constraintEqualToConstant(1),
            
            characterNumberLabel.centerYAnchor.constraintEqualToAnchor(subjectField.centerYAnchor),
            characterNumberLabel.trailingAnchor.constraintEqualToAnchor(subjectField.layoutMarginsGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - HELPER METHODS
    func updateCharacterLabel(forCharCount length: Int) {
        characterNumberLabel.text = String(25 - length)
    }
    
    
    func updateNextButton(forCharCount length: Int) {
        if length == 0 {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
            navigationItem.rightBarButtonItem?.enabled = false
        } else {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    // MARK: - ACTIONS
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func next() {
        
    }
    
    
}


extension ANNewGroupViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCaracterCount = textField.text?.characters.count ?? 0
        let newLength = currentCaracterCount + string.characters.count - range.length
        
        if newLength <= 25 {
            updateCharacterLabel(forCharCount: newLength)
            updateNextButton(forCharCount: newLength)
            return true
        }
        return false
        
        
    }
    
}
























