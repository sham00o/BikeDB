//
//  RegisterController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/28/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate, BikePickerDelegate {
    
    //
    // Here we start collecting bike information and pass it into the next views to be put into firebase
    //

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBrand: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtSerial: UITextField!
    @IBOutlet weak var btnRed: colorButton!
    @IBOutlet weak var btnOrange: colorButton!
    @IBOutlet weak var btnYellow: colorButton!
    @IBOutlet weak var btnGreen: colorButton!
    @IBOutlet weak var btnBlue: colorButton!
    @IBOutlet weak var btnPurple: colorButton!
    @IBOutlet weak var btnBlack: colorButton!
    @IBOutlet weak var btnGrey: colorButton!
    @IBOutlet weak var btnWhite: colorButton!
    @IBOutlet weak var btnNext: UIButton!
    
    // Bike information object to pass between controllers as the information gets collected that ultimately gets sent up to Firebase
    let bike = BikeInfo()
    
    // Flag to indicate if coming from stolen
    var cameFromStolen = false
    
    var colorSelected = false
    
    var serialOK = false
    
    var dismissKeyboard : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtName.delegate = self
        txtSerial.delegate = self
        txtBrand.delegate = self
        txtType.delegate = self
        dismissKeyboard = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        txtName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        txtSerial.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        txtBrand.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        txtType.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.configureNavBar(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButtons()
    }
    
    func configureButtons() {
        btnRed.color = "red"
        btnOrange.color = "orange"
        btnYellow.color = "yellow"
        btnGreen.color = "green"
        btnBlue.color = "blue"
        btnPurple.color = "purple"
        btnBlack.color = "black"
        btnGrey.color = "grey"
        btnWhite.color = "white"
        btnRed.layer.cornerRadius = 0.5 * btnRed.bounds.size.width
        btnOrange.layer.cornerRadius = 0.5 * btnOrange.bounds.size.width
        btnYellow.layer.cornerRadius = 0.5 * btnYellow.bounds.size.width
        btnGreen.layer.cornerRadius = 0.5 * btnGreen.bounds.size.width
        btnBlue.layer.cornerRadius = 0.5 * btnBlue.bounds.size.width
        btnPurple.layer.cornerRadius = 0.5 * btnPurple.bounds.size.width
        btnBlack.layer.cornerRadius = 0.5 * btnBlack.bounds.size.width
        btnGrey.layer.cornerRadius = 0.5 * btnGrey.bounds.size.width
        btnWhite.layer.cornerRadius = 0.5 * btnWhite.bounds.size.width
        btnWhite.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnWhite.layer.borderWidth = 0.5
    }
    
    @IBAction func setColor(sender: colorButton) {
        colorSelected = true
        bike.color = sender.color
        checkFields()
    }
    
    // segue action when button is activated
    func segue(sender: AnyObject) {
        performSegueWithIdentifier("next", sender: self)
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // set state of btnNext if each textfield is filled and a color is selected
    func checkFields() {
        if serialOK && txtBrand.text != "" && txtType.text != "" && txtSerial.text != "" && colorSelected == true {
            Utils.activateButton(btnNext)
            btnNext.addTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        } else {
            Utils.deactivateButton(btnNext)
            btnNext.removeTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        }
    }
    

    func textFieldDidChange(textField: UITextField) {
        checkFields()
    }
    
    func checkExistingSerial(serial: String) {
        Utils.bikesRef.queryOrderedByChild("serial").queryEqualToValue(serial).observeSingleEventOfType(.Value, withBlock: {
            (snapshot) -> Void in
            let bikes = Utils.snapshotToBikeInfo(snapshot)
            if bikes.count == 0 {
                self.serialOK = true
            } else {
                self.serialOK = false
                Utils.alertUser("Existing serial number", msg: "This serial number is already in our database, please enter a unique one", handle: {(UIAlertAction) -> Void in})
            }
            self.checkFields()
            }, withCancelBlock: {
                (error) -> Void in
                print(error.description)
        })
    }
    
    // MARK: - Textfield Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        view.addGestureRecognizer(dismissKeyboard)
        if textField == txtType {
            let picker = BikePicker()
            picker.bikeDelegate = self
            textField.inputView = picker
            textField.text = picker.bikeTypes[0]
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == txtSerial {
            checkExistingSerial(txtSerial.text!)
        }
        checkFields()
        view.removeGestureRecognizer(dismissKeyboard)
    }
    
    // MARK: - Picker Methods
    
    func textFieldToSet() -> UITextField {
        return txtType
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "next" {
            let dest = segue.destinationViewController as! RegisterPhotoController
            bike.name = txtName.text
            bike.brand = txtBrand.text
            bike.type = txtType.text
            bike.serial = txtSerial.text
            dest.bike = bike
            dest.cameFromStolen = cameFromStolen
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

class colorButton : UIButton {
    var color : String!
}
