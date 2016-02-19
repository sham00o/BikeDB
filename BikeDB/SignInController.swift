//
//  SignInController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController, UITextFieldDelegate {
    
    //
    // This controller is for receiving account credentials from the user to fetch their data from our database (i.e. log in)
    //

    var dismissKeyboard : UITapGestureRecognizer!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        dismissKeyboard = UITapGestureRecognizer(target: self, action: "hideKeyboard:")

        Utils.configureNavBar(self)

    }
    
    @IBAction func login(sender: AnyObject) {
        Utils.firebase.authUser(email.text, password: password.text, withCompletionBlock: {
            (error, data) -> Void in
            if error != nil {
                print("ERROR (login): \(error)")
                // Display login error to user
                self.presentViewController(Utils.alertUser("Login Error", msg: "Please check your email, password, and network connection", handle: {(UIAlertAction) -> Void in }), animated: true, completion: nil)
                return
            } else {
                print("SUCCESS (login): \(data.uid)")
                
                // save user id for checking login state
                Utils.defaults.setObject(data.uid, forKey: "uid")
                // start observing and save Firebase reference to user's bikes
                Utils.observeMyBikes(data.uid)
                
                self.getAccountDetails(data.uid)
                
                self.performSegueWithIdentifier("unwind", sender: self)
            }
        })
    }
    
    func getAccountDetails(uid: String){
        let userRef = Utils.firebase.childByAppendingPath("users").childByAppendingPath(uid)
        userRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot -> Void in
            Utils.defaults.setObject(snapshot.value["name"] as! String, forKey: "name")
            Utils.defaults.setObject(snapshot.value["email"] as! String, forKey: "email")
            Utils.defaults.setObject(snapshot.value["phone"] as! String, forKey: "phone")
        })
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
