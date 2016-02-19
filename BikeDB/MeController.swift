//
//  MeController.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/4/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class MeController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bikeContainer: UIView!
    @IBOutlet weak var accountContainer: UIView!
    @IBOutlet weak var control: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utils.configureNavBar(self)
        adjustNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Save the Bike"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        control.layer.cornerRadius = 15
        control.layer.borderColor = Utils.defaultColor.CGColor
        control.layer.borderWidth = 1.0
        control.layer.masksToBounds = true
    }

    func adjustNavigationBar() {
        let item = toolbar.items!.first
        item!.width = self.view.frame.width - 40
    }
    
    @IBAction func switchControl(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            bikeContainer.hidden = true
            accountContainer.hidden = false
        } else {
            bikeContainer.hidden = false
            accountContainer.hidden = true
        }
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
