//
//  CreateAccountController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountController: UIViewController, UITextFieldDelegate {

    //
    // This controller takes user-input up to Firebase to make an account that the user will need to log in with
    //
    
    // reference to firebase for creating an account on the database
    let firebase = Firebase(url: "burning-inferno-5216.firebaseio.com")
    
    var dismissKeyboard : UITapGestureRecognizer!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissKeyboard = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
    }

    @IBAction func signUp(sender: AnyObject) {
        if goodInput() {
            firebase.createUser(email.text, password: password.text, withValueCompletionBlock: {
                (error, data) -> Void in
                if (error != nil) {
                    print("ERROR (sign up): \(error)")
                    self.presentViewController(Utils.alertUser("Sign up Error", msg: error.localizedDescription, handle: {(UIAlertAction) -> Void in }), animated: true, completion: nil)
                } else {
                    if let uid = data["uid"]  {
                    print("SUCCESS (sign up): \(uid)")
                        
                        let user = ["email":self.email.text!]
                    
                    // save user data into database
                    // create child path in 'users' and store information under unique uid
                    let uidRef = self.firebase.childByAppendingPath("users").childByAppendingPath(uid as! String)
                        uidRef.setValue(user)
                        
                    self.performSegueWithIdentifier("createdAccount", sender: self)
                    }
                }
            })
        }
    }
    
    func goodInput() -> Bool {
        if password.text != confirm.text {
            presentViewController(Utils.alertUser("Input Error", msg: "Passwords do not match", handle: {(UIAlertAction) -> Void in }), animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Textfield Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.addGestureRecognizer(dismissKeyboard)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.removeGestureRecognizer(dismissKeyboard)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
