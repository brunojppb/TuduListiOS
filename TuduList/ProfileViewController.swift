//
//  ProfileViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/3/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, LoginViewControllerDelegate {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var imageSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil{
            self.performSegueWithIdentifier("LoginScreen", sender: self)
        }
        else{
            self.loadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginScreen"{
            println("PrepareForSegue")
            let controller:LoginViewController = segue.destinationViewController as LoginViewController
            controller.delegate = self;
        }
    }
    
    func loadData(){
        self.imageSpinner.hidden = false
        self.imageSpinner.startAnimating()
        let request:FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            if error == nil{
                if let dict = result as? Dictionary<String, AnyObject>{
                    let name:String = dict["name"] as AnyObject? as String
                    let birthday:String = dict["birthday"] as AnyObject? as String
                    let facebookID:String = dict["id"] as AnyObject? as String
                    
                    self.nameLabel.text = name
                    self.birthLabel.text = birthday
                    
                    let url:NSURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
                    let request:NSURLRequest = NSURLRequest(URL: url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
                        completionHandler: { (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                            if connectionError == nil && data != nil{
                                //plot the image in the imageView
                                self.profilePictureImageView.image = UIImage(data: data)
                                self.imageSpinner.stopAnimating()
                                self.imageSpinner.hidden = true
                            }
                    })
                }
            }
        }
    }
    
    func didFinishLogin() {
        println("Delegate Works!")
        self.loadData()
    }
}
