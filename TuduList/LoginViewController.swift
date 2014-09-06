//
//  ViewController.swift
//  TuduList
//
//  Created by Bruno Paulino on 9/3/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit


protocol LoginViewControllerDelegate{
    func didFinishLogin()
}


class LoginViewController: UIViewController {
    
    var profileView:ProfileViewController = ProfileViewController();
    var delegate:LoginViewControllerDelegate?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookLogin(sender: UIButton) {
        //facebook permissions
        let permissions:[String] = ["user_about_me", "user_relationships", "user_birthday", "user_location"]
        
        //Login PFUser using Facebook
        PFFacebookUtils.logInWithPermissions(permissions) { (user, error) -> Void in
            if user == nil{
                var errorMessage:String
                if error == nil{
                    println("The user cancelled the Facebook Login")
                    errorMessage = "The user cancelled the Facebook Login"
                }else{
                    println("An error occurred: \(error)")
                    errorMessage = error.localizedDescription
                }
                
                let alert:UIAlertView = UIAlertView(title: "Login Error", message: errorMessage, delegate: nil, cancelButtonTitle: "Dismiss")
                alert.show()
                
            }else{
                if user.isNew{
                    println("New User! Signed Up and Logged In!")
                }else{
                    println("User with facebook Logged in")
                }
                
                self.delegate?.didFinishLogin()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

































