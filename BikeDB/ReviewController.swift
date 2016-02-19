//
//  ReviewController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/9/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class ReviewController: UIViewController {

    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var detailedView: UIView!
    @IBOutlet weak var control: UISegmentedControl!
    
    // Bike object
    var bike : BikeInfo!
    
    // Flag to indicate if coming from stolen track
    var cameFromStolen = false
    // Value to set "stolen" to
    var value : String!
    
    // Flag to indicate if coming from report track
    var cameFromReport = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configButton()
        initializeViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        control.layer.cornerRadius = 15
        control.layer.borderColor = Utils.defaultColor.CGColor
        control.layer.borderWidth = 1.0
        control.layer.masksToBounds = true
    }
    
    func initializeViews() {
        activityView.hidden = false
        detailedView.hidden = true
        if cameFromStolen {
            checkIfStolen()
        }
    }
    
    func configButton() {
        Utils.activateButton(btnPost)
        btnPost.layer.cornerRadius = 15.0
    }
    
    @IBAction func controlChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // activity
            activityView.hidden = false
            detailedView.hidden = true
        } else { // detailed selected
            activityView.hidden = true
            detailedView.hidden = false
        }
    }
    
    @IBAction func postToDB(sender: AnyObject) {
        if cameFromStolen {
            if value == "true" {
                setStolen()
                performSegueWithIdentifier("describe_incident", sender: self)
            } else {
                setNotStolen()
                performSegueWithIdentifier("success", sender: self)
            }
        }
        if cameFromReport {
            reportIncident()
            performSegueWithIdentifier("success", sender: self)
        }
    }
    
    func reportIncident() {
        if bike.reference != nil {
            bike.reference.updateChildValues([
                "address":bike.address.uppercaseString,
                "city":bike.city.uppercaseString,
                "state":bike.state.uppercaseString,
                "date":bike.date,
                "month":bike.month.uppercaseString,
                "time":bike.time.uppercaseString,
                "incident":bike.incident])
        } else {
            Utils.addBikeToFirebase(bike)
        }
    }
    
    func setNotStolen() {
        bike.reference.updateChildValues([
            "stolen" : value,
            "address" : "",
            "city" : "",
            "state" : "",
            "date" : "",
            "month" : "",
            "time" : "",
            "incident" : ""])
        bike.stolen = value
    }
    
    func setStolen() {
        bike.reference.updateChildValues(["stolen" : value])
        bike.stolen = value
    }
    
    func checkIfStolen() {
        if bike.stolen == "false" {
            value = "true"
            btnPost.setTitle("Mark this bike stolen", forState: UIControlState.Normal)
        } else {
            value = "false"
            btnPost.setTitle("Mark this bike NOT stolen", forState: .Normal)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "activity_embed" {
            let dest = segue.destinationViewController as! ActivityController
            dest.bike = bike
        }
        if segue.identifier == "detailed_embed" {
            let dest = segue.destinationViewController as! DetailedController
            dest.bike = bike
        }
        if segue.identifier == "describe_incident" {
            let dest = segue.destinationViewController as! ReportController
            dest.cameFromStolen = cameFromStolen
            dest.bike = bike
        }
    }

}
