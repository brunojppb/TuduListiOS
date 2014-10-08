    //
//  TuduItemsViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/5/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit
import CoreData

class TuduItemsViewController:  UITableViewController,
                                LoginViewControllerDelegate,
                                NSFetchedResultsControllerDelegate {
    
    var managedObjectContext:NSManagedObjectContext?
    
    //lazy initialization
    lazy var fetchedResultsController:NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("TuduItem", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        //sorting objects
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "TuduItems")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil{
            //Show the screen to log in the user
            self.showLoginScreen()
        }else{
            //clear previews cache in memory
            NSFetchedResultsController.deleteCacheWithName("TuduItems")
            self.performFetch()
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo:[AnyObject] = self.fetchedResultsController.sections!
        return sectionInfo[section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as TuduListCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        switch editingStyle{
        case .Delete:
            let tuduItem:TuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
            self.managedObjectContext?.deleteObject(tuduItem)
        
        default:
            println("Default...")
        }
        
    }
        

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tuduItem:TuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
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
            itemDetailViewController.title = "Edit Item"
            itemDetailViewController.itemToEdit = tuduItem
            itemDetailViewController.managedObjectContext = self.managedObjectContext
        }
        else if segue.identifier == "AddItem"{
            println("AddItem!")
            let navigationController:UINavigationController = segue.destinationViewController as UINavigationController
            let itemDetailViewController:ItemDetailViewController = navigationController.topViewController as ItemDetailViewController
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
    }
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    //MARK - Auxiliar Functions
    func didFinishLogin(){
        //load objects from CoreData Store
        self.performFetch()
        
        
        //load objects from Parse
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
    
    func configureLabelForDueDate(LabelToEdit label:UILabel, dateToInsert date:NSDate) ->Void{
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a '-' MM/dd/YY"
        label.text = formatter.stringFromDate(date)
    }
    
    //TuduListCell Button Function to perform the edit action
    func editTuduItem(buttonClicked button:UIButton) ->Void{
        
    }
    
    //load data from CoreData
    func performFetch() -> Void{
        self.fetchedResultsController.performFetch(nil)
    }
    
    func configureCell(cell:TuduListCell, atIndexPath indexPath:NSIndexPath) -> Void{
        let tuduItem:TuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
        cell.titleLabel.text = tuduItem.title
        self.configureLabelForDueDate(LabelToEdit: cell.dueDateLabel, dateToInsert: tuduItem.dueDate as NSDate)
    }
    
    //MARK - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        
        switch type{
        case .Insert:
            NSLog("NSFetchedResultsChangeInsert (object)")
            self.tableView.insertRowsAtIndexPaths([newIndexPath] as [AnyObject], withRowAnimation: .Fade)
        
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Fade)
            
        case .Update:
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as TuduListCell
            self.configureCell(cell, atIndexPath: indexPath)
        
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        
        default:
            println("Default... No operations...")
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type{
        
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
        default:
            println("Default... No operations...")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    //new Dealoc method (Swift...)
    deinit{
        self.fetchedResultsController.delegate = nil
    }

}



















