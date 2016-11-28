//
//  FirsPage.swift
//  Word Scanner
//
//  Created by XCode Developer (iOS/MacOS) on 2016-11-27.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit

class FirsPage: UIViewController {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPerformSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        let userLogin=prefs.stringForKey("userLogin")
        print(userLogin)
        
        if (userLogin?.isEmpty != nil)
        {
            return true
        }
        else
        {
            return false
        }
        
    }

}
