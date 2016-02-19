//
//  AddressController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/6/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

//
// UITextField subclass to hide blinking caret
//
class NoCursorTextField : UITextField {
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

class DetailsController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var txtDate: NoCursorTextField!
    @IBOutlet weak var txtTime: NoCursorTextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var btnNext: UIButton!
    
    // Bike object to send to Firebase
    var bike : BikeInfo!
    
    // Flag to indicate stolen track
    var cameFromStolen = false
    
    // Address dictonary passed in from ReportController
    var dict = [String:String]()
    
    var tapDismiss : UITapGestureRecognizer!
    var descFlag = false
    var dateFlag = false
    var timeFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblAddress.text = dict["Street"]
        lblCity.text = dict["City"]
        lblState.text = dict["State"]
        
        tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        view.addGestureRecognizer(tapDismiss)
    }

    @IBAction func datePicker(sender: UITextField) {
        let picker = UIDatePicker()
        if sender == txtDate {
            picker.datePickerMode = .Date
            picker.addTarget(self, action: "handleDate:", forControlEvents: .ValueChanged)
        } else if sender == txtTime {
            picker.datePickerMode = .Time
            picker.addTarget(self, action: "handleTime:", forControlEvents: .ValueChanged)
        }
        sender.inputView = picker
    }
    
    func handleDate(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        txtDate.text = dateFormatter.stringFromDate(sender.date)
        dateFlag = true
        checkInputs()
    }
    
    func handleTime(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        txtTime.text = dateFormatter.stringFromDate(sender.date)
        timeFlag = true
        checkInputs()
    }
    
    func checkInputs() {
        if dateFlag && timeFlag && descFlag {
            Utils.activateButton(btnNext)
            btnNext.addTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        } else {
            Utils.deactivateButton(btnNext)
            btnNext.removeTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        }
    }
    
    func segue(sender: UIButton) {
        let dates = txtDate.text?.componentsSeparatedByString(" ")
        bike.setFields(lblAddress.text!, ci: lblCity.text!, st: lblState.text!, da: dates![0] , mo: dates![1], ti: txtTime.text!, inc: txtDesc.text)
        if cameFromStolen {
            bike.setStolen()
            performSegueWithIdentifier("review", sender: self)
        } else {
            performSegueWithIdentifier("report_photo", sender: self)
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Textfield methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.textColor = UIColor.darkGrayColor()
        let datePicker = UIDatePicker()
        if textField == txtDate {
            datePicker.datePickerMode = .Date
            handleDate(datePicker)
        } else if textField == txtTime {
            datePicker.datePickerMode = .Time
            handleTime(datePicker)
        }
    }
        
    // MARK: - Textview methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.darkGrayColor()
        if textView.text == "ex. I saw the face of the guy who stole my bike. He was wearing an Iron Man mask." {
            textView.text = ""
            descFlag = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = "ex. I saw the face of the guy who stole my bike. He was wearing an Iron Man mask."
        } else {
            descFlag = true
        }
        checkInputs()
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "report_photo" {
            let dest = segue.destinationViewController as! RegisterPhotoController
            dest.bike = bike
        } else {
            let dest = segue.destinationViewController as! ReviewController
            dest.bike = bike
            dest.cameFromReport = true
        }
    }
    
}
