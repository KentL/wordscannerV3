//
//  HistoryViewController.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-08.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UITableViewController{

    var historyList=[NSManagedObject]()
    let cellID="HistoryItem"
    var appDelegate:AppDelegate?
    var managedContext: NSManagedObjectContext?
    let prefs = NSUserDefaults.standardUserDefaults()
    var userEmail:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
            }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userEmail = prefs.stringForKey("userLogin")!
        
        // Load history record from database and refresh table view data
        
  
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "History")
        fetchRequest.returnsObjectsAsFaults=false;
        fetchRequest.predicate=NSPredicate(format: "email = %@", userEmail!)
        do {
            let results = try managedContext!.executeFetchRequest(fetchRequest)
            historyList = results as! [NSManagedObject]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // CellForRowAtIndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        let history=historyList[indexPath.row]
        cell.textLabel?.text = history.valueForKey("content") as? String
        let imageURL = history.valueForKey("imageURL") as! String
        if NSFileManager.defaultManager().fileExistsAtPath(imageURL){
            do {
            let readData = try NSData(contentsOfFile: imageURL, options: [])
            let retrievedImg = UIImage(data: readData)
            cell.imageView?.image=retrievedImg
            }
            catch
            {
                cell.imageView?.image=UIImage(named: "blank")
            }
        }else{
            cell.imageView?.image=UIImage(named: "blank")
        }
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let history=historyList[selectedRow]
        if let detailViewController = segue.destinationViewController as? DetailViewController {
            detailViewController.historyObject=history
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let deletedItem = historyList.removeAtIndex(indexPath.row)
            managedContext?.deleteObject(deletedItem)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    // Number of Section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {return 1 }
    
    // Number of Rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return historyList.count }
    

    
}
