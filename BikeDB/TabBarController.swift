//
//  TabBarController.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/1/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let report = viewControllers![1] as? BikesController {
            report.cameFromStolen = true
        }
        if let find = viewControllers![2] as? FindController {
            find.fromTabController = true
        }
        
        tabBar.tintColor = Utils.defaultColor
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
