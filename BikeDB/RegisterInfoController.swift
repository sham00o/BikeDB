//
//  RegisterInfoController.swift
//  BikeDB
//
//  Created by Samuel Liu on 10/6/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class RegisterInfoController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    //
    // This controller will take all the bike information passed for the previous views and submit it to firebase under the <firebase>/bikes/<uid>
    //

    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var txtFeatures: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    // Firebase reference
    let firebase = Firebase(url: "burning-inferno-5216.firebaseio.com")
    
    // reference to user defaults for account persistence
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Bike infomation to be sent to Firebase
    var bike : BikeInfo!
    
    // Flag to check if Features field is filled out
    var featuresEntered = false
    
    // Flag to check if came from stolen track
    var cameFromStolen = false
    
    var tapDismiss : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapDismiss = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        view.addGestureRecognizer(tapDismiss)
        
    }
    
    // Get reference to bikes space in database and send bike information
    func submitBikeInfo(sender: AnyObject) {
        bike.value = txtValue.text
        bike.features = txtFeatures.text
        
        Utils.addBikeToFirebase(bike)
        
        if cameFromStolen {
            performSegueWithIdentifier("describe", sender: bike)
        } else {
            performSegueWithIdentifier("unwind_home", sender: self)

        }
    }
    
    func checkFields() {
        if txtValue.text != "" && featuresEntered {
            Utils.activateButton(btnSubmit)
            btnSubmit.addTarget(self, action: "submitBikeInfo:", forControlEvents: .TouchUpInside)
        } else {
            Utils.deactivateButton(btnSubmit)
            btnSubmit.removeTarget(self, action: "submitBikeInfo", forControlEvents: .TouchUpInside)
        }
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Textview methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkFields()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGrayColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text != "" {
            featuresEntered = true
        } else {
            featuresEntered = false
            textView.text = "ex. This is a mountain bike with pink rubber bands on the handle."
            textView.textColor = UIColor.lightGrayColor()
        }
        checkFields()
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
