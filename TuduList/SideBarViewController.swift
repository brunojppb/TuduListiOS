//
//  SideBarViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 10/10/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class SideBarViewController: UITableViewController {
    
    let menuItems = ["Main", "Thanks"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        self.tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor(white: 0.8, alpha: 1.0)

        // Configure the cell...

        return cell
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Main"{
            
        }
        
        if segue.isKindOfClass(SWRevealViewControllerSegue){
            
            let swSegue:SWRevealViewControllerSegue = segue as SWRevealViewControllerSegue
            swSegue.performBlock = {(rvc_segue, svc, dvc) in
                var nc = self.revealViewController().frontViewController as UINavigationController
                nc.setViewControllers([dvc], animated: false)
                self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: true)
            }
        }
    
    }
    

}















