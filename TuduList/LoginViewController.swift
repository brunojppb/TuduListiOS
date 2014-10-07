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
    
    
    //MARK - UI components
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func login(sender: AnyObject) {
    }
    
    @IBAction func signUp(sender: AnyObject) {
    }
    
    
    var delegate:LoginViewControllerDelegate?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtons()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureButtons(){
        //login button customization
        let loginInsets:UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let loginBackgroundImage:UIImage = UIImage(named: "greenButton.png").resizableImageWithCapInsets(loginInsets)
        self.loginButton.setBackgroundImage(loginBackgroundImage, forState: UIControlState.Normal)
        //signup button customization
        let signupInsets:UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let signupBackgroundImage:UIImage = UIImage(named: "orangeButton.png").resizableImageWithCapInsets(signupInsets)
        self.signUpButton.setBackgroundImage(signupBackgroundImage, forState: UIControlState.Normal)
        
        
    }

}

































