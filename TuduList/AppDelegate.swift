//
//  AppDelegate.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/3/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    let ParseAppID:String! = "XuI4Z9QGBzbSQoW2u7soBAuzocB8jnJ7vUYghYwF"
    let ParseClientKey:String! = "X8KMqOHjcWNwHQdGACG0uUlfN334tXy8L0rmbvFZ"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFFacebookUtils.initializeFacebook()
        
//        var testObj:PFObject = PFObject(className: "TestClass")
//        testObj["name"] = "Bruno!"
//        
//        testObj.saveInBackgroundWithBlock { (success, error) -> Void in
//            if success{
//                println("Saved!")
//            }else{
//                println("There was problem :(")
//            }
//        }
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
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


}

