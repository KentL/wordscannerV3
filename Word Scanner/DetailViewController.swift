//
//  DetailControllerViewController.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-12.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var appDelegate:AppDelegate?
    var managedContext: NSManagedObjectContext?
    var historyObject: NSManagedObject?
    
    let recognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.userInteractionEnabled=true
        recognizer.addTarget(self, action: #selector(DetailViewController.imageTapped))
        imageView.addGestureRecognizer(recognizer)
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedContext = appDelegate!.managedObjectContext
        managedContext!.deleteObject(historyObject!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func imageTapped() {
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let imageURL = historyObject!.valueForKey("imageURL") as! String
        let content = historyObject!.valueForKey("content") as? String
        if let text = content {
            textView.text=text
        }
        // If image file exists, set it as imageview
        if NSFileManager.defaultManager().fileExistsAtPath(imageURL){
            do {
                let readData = try NSData(contentsOfFile: imageURL, options: [])
                imageView.image = UIImage(data: readData)
            }catch{
                
                print("failed to read image")
            }
        }
        //If image file doesn't exist, ask user whether delete this record
        else{
            imageView.image = UIImage(named: "blank")
            
            let deleteAlert = UIAlertController(title: "Image Deleted", message: "The image of this record is lost, do you want to delete this record now?", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                self.deleteButtonTapped(self)
            }))
            deleteAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            presentViewController(deleteAlert, animated: true, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
