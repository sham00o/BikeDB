//
//  StolenController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class FindController: UIViewController, UITextFieldDelegate, BikeTableDelegate, BikePickerDelegate {
    
    //
    // This controller is to search our database for a specific bike
    //
    
    // Array of bike info objects to retrieve from firebase
    var bikes = [BikeInfo]()
    
    var queried = false // only query firebase once
    var expanded = true
    var dismissKeyboard : UITapGestureRecognizer!
    var fromTabController = false

    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var tableBikes: BikeTable!
    
    @IBOutlet weak var txtSerial: UITextField!
    @IBOutlet weak var txtBrand: UITextField!
    @IBOutlet weak var txtType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        view.addGestureRecognizer(dismissKeyboard)
        
        tableBikes.segueDelegate = self
        
        configureViews()
        expandFields(btnToggle) // set to minimized view

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.configureNavBar(self)
        if fromTabController {
            tabBarController?.title = "Find the Bike"
        }
    }
    
    func configureViews(){
        tableBikes.hidden = true
        btnToggle.layer.cornerRadius = 5.0
        fieldsView.layer.cornerRadius = 5.0
        fieldsView.layer.borderWidth = 0.15
    }

    @IBAction func expandFields(sender: AnyObject) {
        if expanded == false {
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseInOut, animations: {
                    self.viewHeightConst.constant = 240
                    self.view.layoutIfNeeded()
                }, completion: nil)
            btnToggle.setTitle("Less", forState: .Normal)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.viewHeightConst.constant = 90
                self.view.layoutIfNeeded()
                }, completion: nil)
            btnToggle.setTitle("More", forState: .Normal)
        }
        expanded = !expanded
    }
    
    // Query firebase with the filled out textfields for bike info objects to fill table
    func queryBikes(textField: UITextField, child: String) {
        let bikesRef = Utils.firebase.childByAppendingPath("bikes")

        if let text = textField.text {
            print("querying: \(child),\(text)")

            // attach closure to read the data from 'bikes/'
            bikesRef.queryOrderedByChild(child).queryEqualToValue(text).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                self.queried = true
//                print("query returned: \(snapshot.value)")
                // convert firebase into bike info object
                self.bikes = self.filterStolen(Utils.snapshotToBikeInfo(snapshot))
                print("Num bikes retrieved: \(self.bikes.count)")
                self.tableBikes.hidden = false
                self.tableBikes.bikes = self.bikes
                self.tableBikes.reloadData()
                }, withCancelBlock: {(error) -> Void in
                    print(error.description)
            })
        }
    }
    
    // Remove bikes that are not marked as stolen
    func filterStolen(bikes: [BikeInfo]) -> [BikeInfo] {
        var stolen = [BikeInfo]()
        for bike in bikes {
            if bike.stolen == "true" {
                stolen.append(bike)
            }
        }
        return stolen
    }
    
    // Remove bikeinfo objects that dont match this textField
    func filterBikes(textField: UITextField, type: String) {
        print("filtering")
        var filteredBikes = [BikeInfo]()
        
        if let text = textField.text {
            for bike in bikes {
                if type == "brand" && bike.brand == text {
                    filteredBikes.append(bike)
                } else if type == "type" && bike.type == text { // filter for type
                    filteredBikes.append(bike)
                } else if type == "serial" && bike.serial == text {
                    filteredBikes.append(bike)
                }
            }
        }
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func segueFromBike(index: Int) {
        // segue to detail view controller and send the selected bike
        print("seguing")
        performSegueWithIdentifier("detail", sender: bikes[index])
    }
    
    func setType() -> BikeTableType {
        return BikeTableType.Stolen
    }
    
    func textFieldToSet() -> UITextField {
        return txtType
    }
    
    // MARK: - Textfield methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == txtType {
            let picker = BikePicker()
            picker.bikeDelegate = self
            textField.inputView = picker
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" { return }
        // reset table and query status
        if txtSerial.text != "" || txtBrand.text != "" || txtType.text != "" {
            bikes = [BikeInfo]()
            tableBikes.reloadData()
            tableBikes.hidden = true
            queried = false
        }
        // Hide instruction text
        UIView.animateWithDuration(0.5, animations: {
            self.lblInstruction.hidden = true
            self.viewTopConst.constant = 8
            self.view.layoutIfNeeded()
        })
        
        var type = "type"
        if textField == txtSerial {
            type = "serial"
        } else if textField == txtBrand {
            type = "brand"
        }
        
        if !queried {
            // make query after textfield have finished
            queryBikes(textField, child: type)
        } else {
            filterBikes(textField, type: type)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! DetailedController
        dest.bike = sender as! BikeInfo
    }


}