//
//  AppDelegate.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/3/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    let ParseAppID:String! = "XuI4Z9QGBzbSQoW2u7soBAuzocB8jnJ7vUYghYwF"
    let ParseClientKey:String! = "X8KMqOHjcWNwHQdGACG0uUlfN334tXy8L0rmbvFZ"
    let DEBUG = true
    
    lazy var managedObjectContext:NSManagedObjectContext = {
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = (urls[urls.endIndex-1]).URLByAppendingPathComponent("DataStore.sqlite")
        
        var error: NSError? = nil
        
        var store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
        if (store == nil) {
            println("Failed to load store")
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = psc
        
        return managedObjectContext
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFFacebookUtils.initializeFacebook()
        
        
        let navigationController:UINavigationController = self.window?.rootViewController as UINavigationController
        let firstViewController:TuduItemsViewController = navigationController.viewControllers[0] as TuduItemsViewController
        
        firstViewController.managedObjectContext = self.managedObjectContext
        
        //configure local notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("DidReceiveNotification caled: \(notification)")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [PFFacebookUtils.session().close()]
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
    
    func ZAssert(test: Bool, message: String) {
        if (test) {
            return
        }
        
        println(message)
        
        if (!DEBUG) {
            return
        }
        
        var exception = NSException()
        exception.raise()
    }
    
}

