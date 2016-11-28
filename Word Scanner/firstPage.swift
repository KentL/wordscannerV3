//
//  firstPage.swift
//  Word Scanner
//
//  Created by XCode Developer (iOS/MacOS) on 2016-11-28.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import UIKit

class firstPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       
    }

}
