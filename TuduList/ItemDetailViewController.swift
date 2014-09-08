//
//  ItemDetailViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/5/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate{
    func didFinishEditingItem()
}

class ItemDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindmeSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var remindMeLabel: UILabel!
    
    var delegate:ItemDetailViewControllerDelegate?
    
    var itemToEdit:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        if self.itemToEdit == nil{
            self.doneButton.enabled = false
            self.remindMeDate = NSDate()
            self.updateDateLabel()
        }else{
            let title:String = self.itemToEdit?["title"] as AnyObject? as String
            let content:String = self.itemToEdit?["content"] as AnyObject? as String
            let dueDate:NSDate = self.itemToEdit?["dueDate"] as AnyObject? as NSDate
            let remindMe:Bool = self.itemToEdit?["remindme"] as AnyObject? as Bool
            
            self.titleText.text = title
            self.contentText.text = content
            self.remindMeDate = dueDate
            self.remindmeSwitch.on = remindMe
            self.datePicker.date = dueDate
            self.updateDateLabel()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var tuduItem:PFObject?
    var remindMeDate:NSDate?

    @IBAction func done(sender: AnyObject) {
        
        self.doneButton.enabled = false
        
        //Will create a new TuduItem Object and save
        if self.itemToEdit == nil{
            if self.titleText.text != ""{
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let tuduItem:PFObject = PFObject(className: "TuduItem")
                tuduItem["title"] = self.titleText.text
                tuduItem["content"] = self.contentText.text
                tuduItem["dueDate"] = self.remindMeDate
                tuduItem["remindme"] = self.remindmeSwitch.on
                tuduItem["user"] = PFUser.currentUser()
                
                tuduItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                    println("trying to save the object")
                    if error == nil{
                        println("Save Success!")
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.delegate?.didFinishEditingItem()
                        self.dismissViewControllerAnimated(true, completion:nil)
                    }
                    else{
                        println("Ops!!! Error saving new Object!")
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        //ALERT THE USER THAT THE SAVING METHOD DID NOT WORK
                        self.showAlertViewWithTitle("Sorry...", message: "An error saving...", viewController: self)
                    }
                })
            }
        }
        //will save modifications on itemToEdit
        else{
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.itemToEdit?["title"] = self.titleText.text
            self.itemToEdit?["content"] = self.contentText.text
            self.itemToEdit?["dueDate"] = self.remindMeDate
            self.itemToEdit?["remindme"] = self.remindmeSwitch.on
            
            self.itemToEdit?.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil{
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.delegate?.didFinishEditingItem()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    println("Ops!!! Error updating Object!")
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    //ALERT THE USER THAT THE SAVING METHOD DID NOT WORK
                    self.showAlertViewWithTitle("Sorry...", message: "An error updating...", viewController: self)
                }
            })
        }
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
        return nil
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
       
    }

}
