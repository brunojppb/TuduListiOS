//
//  ItemDetailViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/5/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit
import CoreData


class ItemDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindmeSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var remindMeLabel: UILabel!
    
    var remindMeDate:NSDate?
    var itemToEdit:TuduItem?
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.addTarget(self,
                                action: Selector("dateChanged:"),
                                forControlEvents: UIControlEvents.ValueChanged)
        
        if self.itemToEdit == nil{
            self.doneButton.enabled = false
            self.remindMeDate = NSDate()
            self.updateDateLabel()
        }else if let tudu:TuduItem = self.itemToEdit{
            self.navigationItem.title = "Edit Item"
            self.titleText.text = tudu.title
            self.contentText.text = tudu.content
            self.remindMeDate = tudu.dueDate
            self.remindmeSwitch.on = tudu.remindMe.boolValue
            self.datePicker.date = tudu.dueDate
            self.updateDateLabel()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: AnyObject) {
        self.titleText.becomeFirstResponder()
        self.titleText.resignFirstResponder()
        
        let viewToShow = self.navigationController?.view
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDModeText
        
        self.doneButton.enabled = false
        
        //tuduItem to be inserted or modified
        var tuduItem:TuduItem
        
        //Will create a new TuduItem Object and save
        if self.itemToEdit == nil{
            hud.labelText = "Saved"
            let ent = NSEntityDescription.entityForName("TuduItem", inManagedObjectContext: self.managedObjectContext)
            tuduItem = TuduItem(entity: ent!, insertIntoManagedObjectContext: self.managedObjectContext)
            tuduItem.title = self.titleText.text
            tuduItem.content = self.contentText.text
            tuduItem.dueDate = self.remindMeDate!
            tuduItem.remindMe = NSNumber(bool: self.remindmeSwitch.on)
        }
        //will save modifications on itemToEdit
        else{
            hud.labelText = "Updated"
            tuduItem = self.itemToEdit!
            tuduItem.title = self.titleText.text
            tuduItem.content = self.contentText.text
            tuduItem.dueDate = self.remindMeDate!
            tuduItem.remindMe = NSNumber(bool: self.remindmeSwitch.on)
        }
        
        tuduItem.checked = NSNumber(bool: false)
        self.managedObjectContext.save(nil)
        self.scheduleNotification(itemToSchedule: tuduItem)
        
        var performCloseScreen = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: Selector("closeScreen"), userInfo: nil, repeats: false)
        
    }
    
    
    /// This method formats the Due Date Label
    ///
    /// :param: none
    /// :returns: Void
    func updateDateLabel() -> Void{
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a '-' MM/dd/YY"
        self.remindMeLabel.text = formatter.stringFromDate(self.remindMeDate!)
    }
    
    /// This method is triggered when the DatePicker changes
    ///
    /// :param: 1. The DatePicker that was changed
    /// :returns: Void
    func dateChanged(datePicker: UIDatePicker) -> Void{
        self.remindMeDate = self.datePicker.date
        self.updateDateLabel()
        
    }
    
    func textField(textField: UITextField!,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String!) -> Bool{
            let textFieldString:NSString = textField.text as NSString
            let newText:String = textFieldString.stringByReplacingCharactersInRange(range, withString: string)
            if newText != ""{
                self.doneButton.enabled = true
            }else{
                self.doneButton.enabled = false
            }
            
            return true
    }
    
    /// Show a AlertViewController with custom title and message
    /// After that, dismiss the AlertViewController
    ///
    /// :param: 
    ///     1. title - The Title of the AlertViewController
    ///     2. message - The message of the AlertViewController
    /// :returns: Void
    func showAlertViewWithTitle(title: String!, message: String!, viewController: UIViewController!) -> Void{
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        viewController.presentViewController(alert, animated: true, completion: { () -> Void in
            viewController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.titleText.becomeFirstResponder()
        self.titleText.resignFirstResponder()
        return nil
    }
    
    func closeScreen() -> Void{
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scheduleNotification(itemToSchedule item:TuduItem) -> Void{
        
        let existingNotification = item.notificationForThisItem()
        if let notification = existingNotification{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            println("Notification removed...")
        }
        
        if self.remindmeSwitch.on && self.remindMeDate?.compare(NSDate()) != NSComparisonResult.OrderedAscending{
            let localNotification = UILocalNotification()
            localNotification.fireDate = item.dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = item.title
            localNotification.soundName = UILocalNotificationDefaultSoundName
            let itemID = item.objectID.URIRepresentation().absoluteString
            localNotification.userInfo = ["itemID": itemID!]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
       
    }

}
