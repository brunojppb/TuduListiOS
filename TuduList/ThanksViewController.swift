//
//  ThanksViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 10/10/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBAction func icon8WebSite(sender: AnyObject) {
        
        let url = NSURL(string: "http://icons8.com/")
        UIApplication.sharedApplication().openURL(url)
        
    }
    @IBAction func SWRevealViewControllerWebSite(sender: AnyObject) {
        let url = NSURL(string: "https://github.com/John-Lluch/SWRevealViewController")
        UIApplication.sharedApplication().openURL(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reveal = self.revealViewController()
        let image = UIImage(named: "side-bar-button")
        let barButton = UIBarButtonItem(image: image, style: .Bordered, target: reveal, action: Selector("revealToggle:"))
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.title = "Special Thanks"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
