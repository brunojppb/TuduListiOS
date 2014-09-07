//
//  ItemDetailViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/5/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindmeSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var remindMeLabel: UILabel!
    
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
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var tuduItem:PFObject?
    var remindMeDate:NSDate?

    @IBAction func done(sender: AnyObject) {
        
        if self.titleText.text != ""{
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let tuduItem:PFObject = PFObject(className: "TuduItem")
            tuduItem["title"] = self.titleText.text
            tuduItem["content"] = self.contentText.text
            tuduItem["dueDate"] = self.remindMeDate
            tuduItem["remindme"] = self.remindmeSwitch.on
            tuduItem["user"] = PFUser.currentUser()
            
            tuduItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success{ 
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.dismissViewControllerAnimated(true, completion:nil)
                }
            })
        }
        
        //dismiss the view and come back to the main screen
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    /// This method is triggered when the DatePIcker
    ///
    /// 1. Prepare your thing
    /// 2. Tell all your friends about the thing.
    /// 3. Call this method to do the thing.
    ///
    /// Here are some bullet points to remember
    ///
    /// * Do it right
    /// * Do it now
    /// * Don't run with scissors (unless it's tuesday)
    ///
    /// :param: name The name of the thing you want to do
    /// :returns: a message telling you we did the thing
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
