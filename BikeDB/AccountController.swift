//
//  AccountController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/29/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class AccountController: UIViewController, UIToolbarDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // if user is logged in
        if Utils.defaults.stringForKey("uid") != nil {
            loadPlaceholders()
        } else {
            self.view.userInteractionEnabled = false
        }
    }

    @IBAction func saveInfo(sender: AnyObject) {
        let userRef = Utils.firebase.childByAppendingPath("users").childByAppendingPath(Utils.defaults.stringForKey("uid"))
        if name.text != "" {
            Utils.defaults.setObject(name.text, forKey: "name")
            userRef.childByAppendingPath("name").setValue(name.text)
            name.text = ""
        }
        if phone.text != "" {
            Utils.defaults.setObject(phone.text, forKey: "phone")
            userRef.childByAppendingPath("phone").setValue(phone.text)
            phone.text = ""
        }
        loadPlaceholders()
    }
    
    func loadPlaceholders() {
        name.placeholder = Utils.defaults.stringForKey("name")
        phone.placeholder = Utils.defaults.stringForKey("phone")
        email.placeholder = Utils.defaults.stringForKey("email")
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
