    //
//  TuduItemsViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/5/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit
import CoreData

class TuduItemsViewController: UITableViewController, LoginViewControllerDelegate,ItemDetailViewControllerDelegate {
    
    var tuduItems:Array<TuduItem> = Array<TuduItem>()
    var managedObjectContext:NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil{
            //Show the screen to log in the user
            showLoginScreen()
        }else{
            didFinishLogin()
        }
    }
    
    func formatDateToFormatedString(date: NSDate) -> String{
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a '-' MM/dd/YY"
        return formatter.stringFromDate(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tuduItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as TuduListCell
        let tuduItem:TuduItem = self.tuduItems[indexPath.row]
        cell.titleLabel.text = tuduItem.title
        self.configureLabelForDueDate(LabelToEdit: cell.dueDateLabel, dateToInsert: tuduItem.dueDate as NSDate)
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let tuduItem:TuduItem = self.tuduItems[indexPath.row]
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.tuduItems.removeAtIndex(indexPath.row)
            
        }
    }
        

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tuduItem:TuduItem = self.tuduItems[indexPath.row]
        self.performSegueWithIdentifier("EditItem", sender: tuduItem)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "EditItem"{
            let tuduItem:TuduItem = sender as TuduItem
            let navigationController:UINavigationController = segue.destinationViewController as UINavigationController
            let itemDetailViewController:ItemDetailViewController = navigationController.topViewController as ItemDetailViewController
            itemDetailViewController.delegate = self
            itemDetailViewController.title = "Edit Item"
            itemDetailViewController.itemToEdit = tuduItem
            itemDetailViewController.managedObjectContext = self.managedObjectContext
        }
        else if segue.identifier == "AddItem"{
            println("AddItem!")
            let navigationController:UINavigationController = segue.destinationViewController as UINavigationController
            let itemDetailViewController:ItemDetailViewController = navigationController.topViewController as ItemDetailViewController
            itemDetailViewController.delegate = self
            itemDetailViewController.managedObjectContext = self.managedObjectContext
        }
        else if segue.identifier == "LoginScreen"{
        
            let loginScreen:LoginViewController = LoginViewController()
            loginScreen.delegate = self
        }
    }
    
    
    //MARK - Internet Reachability
//    func checkInternetConnection(){
//        reachbility = AFNetworkReachabilityManager(forDomain: "www.parse.com")
//        reachbility?.setReachabilityStatusChangeBlock { (status) -> Void in
//            let statusString:String = AFStringFromNetworkReachabilityStatus(status)
//            println("Reachability: \(statusString)")
//        }
//        reachbility?.startMonitoring()
//    }
    
    // MARK: - ItemDetailViewControllerDelegate
    func didFinishEditingItem() {
        //reload item from database
    }
    
    func didFinishSavingNewItem() {
        //reload TuduItems from the Database
        self.loadDataFromDatabase()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if self.tuduItems.isEmpty{
            
        }
    }
    
    func didFinishLogin(){
        
        self.loadDataFromDatabase()
        
        //load objects from CoreData Store
        
//        let query:PFQuery = PFQuery(className: "TuduItem")
//        query.whereKey("user", equalTo:PFUser.currentUser())
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            if error == nil{
//                println("Query works!!")
//                self.tuduItems.removeAll(keepCapacity: false)
//                if let items = objects as? [PFObject]{
//                    for item in items{
//                        self.tuduItems.append(item)
//                    }
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    func showLoginScreen() ->Void{
        self.performSegueWithIdentifier("LoginScreen", sender: self)
    }
    
    //MARK - Configure label for due date
    func configureLabelForDueDate(LabelToEdit label:UILabel, dateToInsert date:NSDate) ->Void{
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a '-' MM/dd/YY"
        label.text = formatter.stringFromDate(date)
    }
    
    //MARK - TuduListCell Button Function
    func editTuduItem(buttonClicked button:UIButton) ->Void{
        
    }
    
    func loadDataFromDatabase() ->Void{
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("TuduItem", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        //sorting objects
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let foundObjects = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        let convertedObjects:Array<TuduItem> = foundObjects as Array<TuduItem>
        
        self.tuduItems = convertedObjects
        
        self.tableView.reloadData()
    }

}



















