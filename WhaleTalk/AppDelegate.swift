//
//  AppDelegate.swift
//  WhaleTalk
//
//  Created by Anton Novoselov on 01/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var contactImporter: ContactImporter?
    
    private var contactsSyncer: ANSyncer?
    
    private var contactsUploadSyncer: ANSyncer?
    private var firebaseSyncer: ANSyncer?
    
    private var firebaseStore: FireBaseStore?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        
        let contactsContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        contactsContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        
        let firebaseContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        firebaseContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        
//        firebaseSyncer = ANSyncer(mainContext: mainContext, backgroundContext: firebaseContext)
        
        let firebaseStore = FireBaseStore(context: firebaseContext)
        self.firebaseStore = firebaseStore
        
        contactsUploadSyncer = ANSyncer(mainContext: contactsContext, backgroundContext: firebaseContext)
        
        contactsUploadSyncer?.remoteStore = firebaseStore
        
        firebaseSyncer = ANSyncer(mainContext: mainContext, backgroundContext: firebaseContext)
        
        firebaseSyncer?.remoteStore = firebaseStore
        
//        contactsUploadSyncer = ANSyncer(mainContext: mainContext, backgroundContext: firebaseContext)
        contactsSyncer = ANSyncer(mainContext: mainContext, backgroundContext: contactsContext)
        
        
        contactImporter = ContactImporter(context: contactsContext)
        
//        importContacts(contactsContext)
        
        let tabController = UITabBarController()
        
        let vcData:[(UIViewController, UIImage, String)] = [
            
            (ANFavoritesViewController(), UIImage(named: "favorites_icon")!, "Favorites"),
            (ANContactsViewController(), UIImage(named: "contact-icon")!, "Contacts"),
            (ANAllChatsViewController(), UIImage(named: "chat-icon")!, "Chats")
            
        ]
        
        let vcs = vcData.map { (vc: UIViewController, image: UIImage, title: String) -> UINavigationController in
            
            if var vc = vc as? ContextViewController {
                vc.context = mainContext
            }
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = image
            nav.title = title
            return nav
            
        }
        
        tabController.viewControllers = vcs

        if firebaseStore.hasAuth() {
            
            firebaseStore.startSyncing()
            
            contactImporter?.listenForChanges()
            
            
            // !!!IMPORTANT!!!
            // ** ADDING UITABBARCONTROLLER IN CODE
            
            
            window?.rootViewController = tabController
        } else {
            
            let vc = ANSignUPViewController()
            vc.remoteStore = firebaseStore
            vc.rootViewController = tabController
            vc.contactImporter = contactImporter
            
            window?.rootViewController = vc
            
        }
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    func importContacts(context: NSManagedObjectContext) {
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("dataSeeded")
        guard !dataSeeded else {return}
        
        contactImporter?.fetch()
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "dataSeeded")
        
    }
    
    
    
    
    
    
}








