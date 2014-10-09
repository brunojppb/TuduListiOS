//
//  TuduItem.swift
//  TuduList
//
//  Created by Bruno Paulino on 10/6/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit
import CoreData

class TuduItem: NSManagedObject {
    
    @NSManaged var objectId:String
    @NSManaged var title:String
    @NSManaged var content:String
    @NSManaged var dueDate:NSDate
    @NSManaged var createdAt:NSDate
    @NSManaged var modifiedAt:NSDate
    @NSManaged var remindMe:NSNumber
    @NSManaged var checked:NSNumber
    
    func notificationForThisItem() -> UILocalNotification?{
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
        for notification in allNotifications{
            if let itemID = notification.userInfo?["itemID"] as? NSString{
                if self.objectID.URIRepresentation().absoluteString == itemID{
                    return notification
                }
            }
        }
        return nil
    }
    
    deinit{
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            println("Notification removed...")
        }
    }
    
   
}
