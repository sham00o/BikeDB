//
//  SuccessController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/10/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class SuccessController: UIViewController {

    @IBOutlet weak var btnHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHome(sender: AnyObject) {
        performSegueWithIdentifier("unwind_home", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
