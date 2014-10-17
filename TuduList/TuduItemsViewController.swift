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
                                NSFetchedResultsControllerDelegate {
    
    var managedObjectContext:NSManagedObjectContext?
    
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
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
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        //SWRevealViewController Configiration
        self.sideBarButton.target = self.revealViewController()
        self.sideBarButton.action = Selector("revealToggle:")
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        self.performFetch()
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
        if let sectionInfo:[AnyObject] = self.fetchedResultsController.fetchedObjects{
            if sectionInfo.count > 0{
                self.tableView.separatorStyle = .SingleLine
                self.tableView.backgroundView = UIView()
                return sectionInfo.count
            }
            else{
                let rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                let label = UILabel(frame: rect)
                label.text = "Your TuduList is empty :("
                label.textColor = UIColor.blackColor()
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont(name: "Palatino-Italic", size: 20)
                label.sizeToFit()
                
                self.tableView.backgroundView = label
                self.tableView.separatorStyle = .None
            }
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as TuduListCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        switch editingStyle{
        case .Delete:
            let tuduItem:TuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
            self.managedObjectContext?.deleteObject(tuduItem)
            self.managedObjectContext?.save(nil)
            
        default:
            println("Default...")
        }
        
    }
        

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:TuduListCell = self.tableView.cellForRowAtIndexPath(indexPath) as TuduListCell
        let tuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
        tuduItem.checked = NSNumber(bool: !tuduItem.checked.boolValue)
        cell.checkedImage.hidden = tuduItem.checked.boolValue
        self.managedObjectContext?.save(nil)
        
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
    }
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    //MARK: - Auxiliar Functions
    
    func showLoginScreen() ->Void{
        self.performSegueWithIdentifier("LoginScreen", sender: self)
    }
    
    func configureLabelForDueDate(LabelToEdit label:UILabel, dateToInsert date:NSDate) ->Void{
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a '-' MM/dd/YY"
        label.text = formatter.stringFromDate(date)
    }
    
    //TuduListCell Button Function to perform the edit action
    func editTuduItem(sender:AnyObject) ->Void{
        let index = (sender as UIButton).tag
        let tuduItemList = self.fetchedResultsController.fetchedObjects
        let tuduItem = tuduItemList?[index] as TuduItem
        self.performSegueWithIdentifier("EditItem", sender: tuduItem)
    }
    
    //load data from CoreData
    func performFetch() -> Void{
        //clear previews cache in memory
        NSFetchedResultsController.deleteCacheWithName("TuduItems")
        self.fetchedResultsController.performFetch(nil)
    }
    
    func configureCell(cell:TuduListCell, atIndexPath indexPath:NSIndexPath) -> Void{
        let tuduItem:TuduItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as TuduItem
        cell.titleLabel.text = tuduItem.title
        cell.checkedImage.hidden = !tuduItem.checked.boolValue
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: Selector("editTuduItem:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.configureLabelForDueDate(LabelToEdit: cell.dueDateLabel, dateToInsert: tuduItem.dueDate as NSDate)
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        
        switch type{
        case .Insert:
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
    
    //MARK - Internet Reachability
    //    func checkInternetConnection(){
    //        reachbility = AFNetworkReachabilityManager(forDomain: "www.parse.com")
    //        reachbility?.setReachabilityStatusChangeBlock { (status) -> Void in
    //            let statusString:String = AFStringFromNetworkReachabilityStatus(status)
    //            println("Reachability: \(statusString)")
    //        }
    //        reachbility?.startMonitoring()
    //    }
    
    //INSIDE a FUNCTION
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



   















