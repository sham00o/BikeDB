//
//  RegisteredBikesController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/20/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class BikesController: UIViewController, UITableViewDelegate, BikeTableDelegate {

    @IBOutlet weak var bikesTable: BikeTable!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var btnTableDistance: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    
    // Title based on segue option
    var heading : String!
    
    // Coming from tab controller
    var fromTabController = false
    
    // Flag to indicate if coming from stolen, this track will:
    // 1) register a bike and set it stolen automatically
    // 2) segue an already-registered bike to be set stolen
    var cameFromStolen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bikesTable.segueDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // register this view to update when bikes get updated
        Utils.notificationCenter.addObserver(self, selector: "updateBikes:", name: "updatedBikes", object: nil)
        
        configureViews()
        configureBikes()
        
        checkIfLoggedIn()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop listening for bike updates
        Utils.notificationCenter.removeObserver(self)
    }
    
    func configureViews() {
        Utils.configureNavBar(self)
        title = heading
        tableHeight.constant = 100.0
        bikesTable.layer.cornerRadius = 5.0
        btnAdd.layer.cornerRadius = 5.0
        if fromTabController {
            title = "Report Bicycle Theft"
        }
        if cameFromStolen {
            tabBarController?.title = "Report Bicycle Theft"
            btnAdd.setTitle("Report a different bike", forState: .Normal)
        } else {
            btnAdd.setTitle("Register a new bike", forState: .Normal)
        }
    }
    
    func configureBikes() {
        bikesTable.bikes = BikeInfo.myBikes
        bikesTable.reloadData()
        // set height to 100 if no bikes, otherwise 158+(178 * number of bikes) up to 5/8 of the view
        let fiveEighths = (5/8)*view.frame.height
        tableHeight.constant = bikesTable.bikes.count == 0 ?
            100.0 :
            CGFloat(158+178*(bikesTable.bikes.count-1)) < fiveEighths ?
                CGFloat(158+178*(bikesTable.bikes.count-1)) :
                fiveEighths
    }
    
    func checkIfLoggedIn() {
        if Utils.defaults.stringForKey("uid") == nil && cameFromStolen == false && fromTabController == false {
            self.presentViewController(Utils.alertUser("No account found", msg: "Create an account or login to enable this part of the app", handle: {(UIAlertAction) -> Void in}), animated: true, completion: nil)
            btnAdd.hidden = true
        }
    }
    
    func updateBikes(notification: NSNotification) {
        configureBikes()
    }
    
    func segueFromBike(index: Int) {
        // segue to report track and send the selected bike
        performSegueWithIdentifier("stolen", sender: bikesTable.bikes[index])
    }
    
    func setType() -> BikeTableType {
        return BikeTableType.Registered
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stolen" {
            if let bike = sender as? BikeInfo {
                let dest = segue.destinationViewController as! ReviewController
                dest.bike = bike
                dest.cameFromStolen = true
            }
        }
        if segue.identifier == "register" {
            let dest = segue.destinationViewController as! RegisterController
            dest.cameFromStolen = cameFromStolen
        }
    }

}
