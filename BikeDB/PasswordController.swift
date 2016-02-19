//
//  PasswordController.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/4/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class PasswordController: UIViewController {

    @IBOutlet weak var current: UITextField!
    @IBOutlet weak var new: UITextField!
    @IBOutlet weak var confirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveChanges(sender: AnyObject) {
        if current.text != new.text && new.text == confirm.text && new.text != "" && current.text != current {
            postChanges()
        }
    }
    
    func postChanges() {
        Utils.firebase.changePasswordForUser(Utils.defaults.stringForKey("uid"), fromOld: current.text,
            toNew: confirm.text, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                    self.presentViewController(Utils.alertUser("Error", msg: "Please make sure your current password is correct and that you confirm the new password matches both fields", handle: {(UIAlertAction) -> Void in }), animated: true, completion: nil)
                } else {
                    // Password changed successfully
                    self.presentViewController(Utils.alertUser("Success", msg: "Your password has been changed", handle: { _ in
                        self.navigationController?.popViewControllerAnimated(true)
                        }), animated: true, completion: nil)
                }

        })
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
