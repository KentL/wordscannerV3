//
//  HomeViewController.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-05.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBOutlet weak var findTextField: UITextField!
    
    @IBOutlet weak var replaceTextField: UITextField!
    
    @IBOutlet weak var chineseSwitch: UISwitch!
  
    @IBOutlet weak var pinyinSwitch: UISwitch!
    
    @IBOutlet weak var Account: UIButton!
    
    let imagePicker = UIImagePickerController()
    let tesseract = Tesseract()
    
    var activityIndicator:UIActivityIndicatorView!
    var localPath:String?
    var textViewContentWithoutPinyin = ""
    var textViewContentWithPinyin = ""
    var userEmail:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate=self
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext

        
        let prefs = NSUserDefaults.standardUserDefaults()
        userEmail = prefs.stringForKey("userLogin")!
        
        let requestUsername = NSFetchRequest(entityName: "Users")
        requestUsername.returnsObjectsAsFaults = false;
        requestUsername.predicate = NSPredicate(format: "email = %@", userEmail!)
        
        
        var resultsUsername:NSArray?
        
        do
        {
            resultsUsername = try context.executeFetchRequest(requestUsername)
            
            if resultsUsername!.count > 0
            {
                let res = resultsUsername![0] as! NSManagedObject
                
                
                let usernameRetrieved = res.valueForKey("username") as! String

                Account.setTitle(usernameRetrieved,forState: .Normal)
      
            }
            
        }
        catch
        {
            print("Error while fetching the user in the database")
        }

        
        
    }
    
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        // if runs on simulator, don't do anything
        #if TARGET_OS_IPHONE
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            // Show image picker
            presentViewController(imagePicker, animated: true, completion: nil)
        #endif
    }
    
    @IBAction func replaceText(sender: UIButton) {
        if let text = resultTextView.text, let findText = findTextField.text, let replaceText = replaceTextField.text {
            resultTextView.text =
                text.stringByReplacingOccurrencesOfString(findText,
                                                          withString: replaceText, options: [], range: nil)
            findTextField.text = nil
            replaceTextField.text = nil
            view.endEditing(true)
        }

    }
   
    //Save button is pressed
    @IBAction func saveButtonPressed(sender: UIButton) {

        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        if localPath == nil {
            showToast()
            return
        }
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("History",
                                                        inManagedObjectContext:managedContext)
        
        let history = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        if let content = resultTextView.text {
            history.setValue(content, forKey: "content")
        }
        if let url = localPath{
            history.setValue(url, forKey: "imageURL")
        }
        history.setValue(NSDate(), forKey: "date")
        
        //creating relationship between user and history
        let requestUsername = NSFetchRequest(entityName: "Users")
        requestUsername.returnsObjectsAsFaults = false;
        requestUsername.predicate = NSPredicate(format: "email = %@", userEmail!)
        
        
        var resultsUsername:NSArray?
        
        do
        {
            resultsUsername = try context.executeFetchRequest(requestUsername)
            
            if resultsUsername!.count > 0
            {
                let res = resultsUsername![0] as! NSManagedObject
                
                
                let emailRetrieved = res.valueForKey("email")
                
                    print("\(emailRetrieved)")
                
                    history.setValue(emailRetrieved, forKey: "email")
                
            }
            
        }
        catch
        {
            print("Error while fetching the user in the database")
        }
   
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        // Show image picker
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When user finished picking an image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        //this block of code grabs the path of the file
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let fileName = formatter.stringFromDate(NSDate())+".png"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        localPath = "\(documentsPath)/\(fileName)"
        
        //this block of code adds data to the above path
        let data = UIImagePNGRepresentation(selectedPhoto)
        data?.writeToFile(localPath!, atomically: true)
        
        addActivityIndicator()
        dismissViewControllerAnimated(true, completion: {self.processImage(selectedPhoto)})
    }
    @IBAction func pinyinSwitchValueChanged(sender: UISwitch) {
        if sender.on{
            resultTextView.text=textViewContentWithPinyin
        }else{
            resultTextView.text=textViewContentWithoutPinyin
        }
    }
    //When user cancelled picking an image
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func processImage(image:UIImage) {
        var content=""
        if chineseSwitch.on{
            content = tesseract.performImageRecognitionWithChinese(image)
        }
        else{
            content=tesseract.performImageRecognitionWithoutChinese(image)
        }
        
        textViewContentWithoutPinyin=content
        textViewContentWithPinyin=content
        
        if content.containsChineseCharacters {
            textViewContentWithPinyin = TextProcessor().AddPinyinToText(content)
        }
        
        if pinyinSwitch.on {
            resultTextView.text = self.textViewContentWithPinyin
        }
        else{
            resultTextView.text=self.textViewContentWithoutPinyin
        }
        removeActivityIndicator()
    }
    // Activity Indicator methods
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    func showToast(){
        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
        toastLabel.backgroundColor = UIColor.darkGrayColor()
        toastLabel.textColor = UIColor.whiteColor()
        toastLabel.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(toastLabel)
        toastLabel.text = "Select an image first"
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animateWithDuration(4.0, delay: 0.1, options: .CurveEaseOut, animations: {
            toastLabel.alpha = 0.0
            }, completion: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(nil, forKey: "userLogin")

       
        
    }
}
