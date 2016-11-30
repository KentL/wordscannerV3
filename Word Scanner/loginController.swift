//
//  loginController.swift
//  Word Scanner
//
//  Created by XCode Developer (iOS/MacOS) on 2016-11-15.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit
import CoreData

class loginController: UIViewController {

    var newUser = user()
    var check: Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        check = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var SignupUsername: UITextField!
    @IBOutlet weak var SignupPassword: UITextField!
    @IBOutlet weak var SignupConfirmPassword: UITextField!
    
    @IBOutlet weak var SignupErrorUsername: UILabel!
    @IBOutlet weak var SignupErrorPassword: UILabel!
    @IBOutlet weak var SignupErrorConfirmPassword: UILabel!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    func signup()
    {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let addUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context)
        
        
        
        if SignupUsername.text?.isEmpty == true
        {
            SignupErrorUsername.text="*Required Field"
        }
        else
        {
            SignupErrorUsername.text=""
        }
        if SignupPassword.text?.isEmpty==true
        {
            SignupErrorPassword.text="*Required Field"
        }
        else
        {
            SignupErrorPassword.text=""
        }
        if SignupConfirmPassword.text?.isEmpty==true
        {
            SignupErrorConfirmPassword.text="*Required Field"
        }
        else
        {
            SignupErrorConfirmPassword.text=""
        }
        if  SignupPassword.text?.isEmpty == false && SignupConfirmPassword.text?.isEmpty == false && SignupUsername.text?.isEmpty == false
        {
            SignupErrorUsername.text=""
            SignupErrorPassword.text=""
            SignupErrorConfirmPassword.text=""
            
            //password not equal confirm password
            if SignupPassword.text != SignupConfirmPassword.text
            {
                print("Password doesnt match")
                SignupErrorConfirmPassword.text="*doesn't match"
            }
                
                
                
            else
            {
                let request = NSFetchRequest(entityName: "Users")
                request.returnsObjectsAsFaults = false;
                request.predicate = NSPredicate(format: "username = %@", SignupUsername.text!)
                
                var results:NSArray?
                
                do
                {
                    results = try context.executeFetchRequest(request)
                    
                    if results!.count > 0
                    {
                        SignupErrorUsername.text="*already exits"
                        print("Username already exists")
                    }
                    else
                    {
                        do
                        {
                            addUser.setValue(SignupUsername.text, forKey: "username")
                            addUser.setValue(SignupPassword.text, forKey: "password")
                            
                            
                            
                            newUser.setUsername(SignupUsername.text!)
                            newUser.setPassword(SignupPassword.text!)
                            newUser.setEmail(SignupUsername.text!+"@wordscanner.com")
                            
                            print(newUser.getEmail())
                            addUser.setValue(newUser.getEmail(), forKey: "email")
                            
                            print("User is added")
                            
                            let prefs = NSUserDefaults.standardUserDefaults()
                            prefs.setValue(newUser.getEmail(), forKey: "userLogin")
                            
                            check=true
                            try context.save()
                            
                        }
                        catch
                        {
                            print("Error while saving context")
                        }
                    }
                    
                    
                }
                catch
                {
                    print("Error while fetching the user in the database")
                }
                
            }
        }

        
    }
    func login()
    {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        
        if username.text?.isEmpty == true
        {
            usernameError.text="*Required Field"
        }
        else
        {
            usernameError.text=""
        }
        if password.text?.isEmpty==true
        {
            passwordError.text="*Required Field"
        }
        else
        {
            passwordError.text=""
        }
        
        if  password.text?.isEmpty == false && username.text?.isEmpty == false
        {
            usernameError.text=""
            passwordError.text=""
            
            
            //password not equal confirm password
           
            let requestUsername = NSFetchRequest(entityName: "Users")
            requestUsername.returnsObjectsAsFaults = false;
            requestUsername.predicate = NSPredicate(format: "username = %@", username.text!)
            
            
            var resultsUsername:NSArray?
                
            do
            {
                resultsUsername = try context.executeFetchRequest(requestUsername)
                
                if resultsUsername!.count > 0
                {
                    let res = resultsUsername![0] as! NSManagedObject
                    let passwordCheck: String = res.valueForKey("password") as! String
                    if password.text != passwordCheck
                    {
                        passwordError.text="Incorrect Password or Username"
                        
                    }
                    else
                    {
                        newUser.setUsername(username.text!)
                        newUser.setPassword(password.text!)
                        newUser.setEmail(username.text!+"@wordscanner.com")
                        
                        let prefs = NSUserDefaults.standardUserDefaults()
                        prefs.setValue(newUser.getEmail(), forKey: "userLogin")
                        
                        print("Login Successful")
                        check=true
                    
                    }
                }
                                
            }
            catch
            {
                print("Error while fetching the user in the database")
            }
                
            
        }

        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if identifier == "loginSegue" {
            login()
        }
        else if identifier == "signupSegue"{
            signup()
        }
        return check
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
  
    }
    
    
}
