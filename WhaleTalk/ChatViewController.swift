//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 01/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    // MARK: - Attributes
    
    private let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    private let newMessageField = UITextView()
    
    private var sections = [NSDate: [Message]]()
    private var dates = [NSDate]()
    
    private var bottomConstraint: NSLayoutConstraint!
    
    private let cellIdentifier = "Cell"
    
    var context: NSManagedObjectContext?
    
    var chat: Chat?
    
    private enum Error: ErrorType {
        case NoChat
        case NoContext
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        // !!!IMPORTANT!!!
        // COREDATA FETCH
        
        do {
            
            guard let chat = chat else {throw Error.NoChat}
            guard let context = context else {throw Error.NoContext}
            
            let request = NSFetchRequest(entityName: "Message")
            
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            
            if let result = try context.executeFetchRequest(request) as? [Message] {
                
                for message in result {
                    addMessage(message)
                }
                
                
            }
        } catch {
            print("We couldn't fetch!")
        }
        
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGrayColor()
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        
        newMessageField.scrollEnabled = false
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.addTarget(self, action: #selector(ChatViewController.pressedSend(_:)), forControlEvents: .TouchUpInside)
        
        sendButton.setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Horizontal)
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true
        
        
        
        let messageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            
            newMessageField.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor, constant: 10),
            newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
            
            sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant: -10),
            
            newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor, constant: -10),
            
            sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
            
            newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant: 20)
        ]
        
        
        NSLayoutConstraint.activateConstraints(messageAreaConstraints)
        
        // !!!IMPORTANT!!!
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "MessageBubble"))
        tableView.separatorColor = UIColor.clearColor()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.scrollToBottom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Gestures
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - Notifications

    // !!!IMPORTANT!!!
    // SLIDING UP AND DOWN NEWMESSAGEAREA WITH KEYBOARD USING NOTIFICATION CENTER
    func keyboardWillShow(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    func updateBottomConstraint(notification: NSNotification) {
        if let
            userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
            
            let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window)!)
            
            bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame)
            
            UIView.animateWithDuration(animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
            
            tableView.scrollToBottom()
        }

    }
    
    // MARK: - Helper Methods
    
    func addMessage(message: Message) {
        
        guard let date = message.timestamp else {return}
        
        let calendar = NSCalendar.currentCalendar()
        
        let startDay = calendar.startOfDayForDate(date)
        
        var messages = sections[startDay]
        
        if messages == nil {
            dates.append(startDay)
            
            // !!!IMPORTANT!!!
            // TRICK - DATES SORTING
            dates = dates.sort({$0.earlierDate($1) == $0})
            
            messages = [Message]()
        }
        
        messages!.append(message)
        messages!.sortInPlace{$0.timestamp!.earlierDate($1.timestamp!) == $0.timestamp!}
        sections[startDay] = messages
        
    }

    
    // MARK: - Actions

    func pressedSend(button: UIButton) {
        guard let text = newMessageField.text where text.characters.count > 0 else {return}
        
        guard let context = context else {return}
        
        guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as? Message else {return}
        
        
        message.text = text
        message.isIncoming = false
        
        message.timestamp = NSDate()
        
        addMessage(message)
        
        
        do {
            try context.save()
        } catch {
            print("There was a problem saving")
            return
        }
        
        
        newMessageField.text = ""
        tableView.reloadData()
        
        tableView.scrollToBottom()
        view.endEditing(true)
        
        
    }
    
}



// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func getMessages(section: Int) -> [Message] {
        let date = dates[section]
        return sections[date]!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageCell
        
        
        // !!!IMPORTANT!!!
        // REMOVE TABLEVIEW SEPARATOR
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        
        let messages = getMessages(indexPath.section)
        
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.text
        cell.incoming(message.isIncoming)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        let paddingView = UIView()
        
        view.addSubview(paddingView)
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
        
            paddingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            paddingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
            
            dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
            
            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
            
            view.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
        
        ]
        
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.stringFromDate(dates[section])
        
        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = true
        
        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1.0)
        
        return view
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}


























