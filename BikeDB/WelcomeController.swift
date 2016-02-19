//
//  ViewController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class WelcomeController: UIViewController {

    //
    // This controller is for logging in and signing up when the user first launches the app
    //
    
    var initialLogin = false
    var logout: UIButton!
    var originalColor : UIColor!
    var originalGrayColor : UIColor!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var skip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bike.jpg")!)
        originalColor = signin.backgroundColor
        originalGrayColor = skip.backgroundColor
        
        signup.addTarget(self, action: "segueToSignUp:", forControlEvents: .TouchUpInside)
        signin.addTarget(self, action: "segueToSignIn:", forControlEvents: .TouchUpInside)
        skip.addTarget(self, action: "skipLogin:", forControlEvents: .TouchUpInside)

        checkPersistentLogin()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
        checkLoginState()
    }
    
    override func viewDidLayoutSubviews() {
        configureOutlets()
    }
    
    func configureOutlets() {
        welcome.layer.shadowOpacity = 0.75
        welcome.layer.shadowOffset = CGSize(width:0, height:3)
        welcome.layer.shadowRadius = 3.0
        
        name.layer.shadowOpacity = 0.75
        name.layer.shadowOffset = CGSize(width:0, height:3)
        name.layer.shadowRadius = 3.0
        
        signup.layer.cornerRadius = 15.0
        signin.layer.cornerRadius = 15.0
        skip.layer.cornerRadius = 15.0
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func transformButtons() {
        signup.hidden = true
        
        skip.setTitle("Logout", forState: .Normal)
        skip.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8)
        signin.setTitle("Continue", forState: .Normal)
        signin.backgroundColor = originalGrayColor
        
        skip.removeTarget(self, action: "skipLogin:", forControlEvents: .TouchUpInside)
        skip.addTarget(self, action: "logout:", forControlEvents: .TouchUpInside)
        
        signin.removeTarget(self, action: "segueToSignIn:", forControlEvents: .TouchUpInside)
        signin.addTarget(self, action: "skipLogin:", forControlEvents: .TouchUpInside)
    }
    
    func revertButtons() {
        signup.hidden = false
        
        skip.setTitle("Skip this", forState: .Normal)
        skip.backgroundColor = originalGrayColor
        signin.setTitle("I'm an existing user", forState: .Normal)
        signin.backgroundColor = originalColor
        
        skip.removeTarget(self, action: "logout:", forControlEvents: .TouchUpInside)
        skip.addTarget(self, action: "skipLogin:", forControlEvents: .TouchUpInside)
        
        signin.removeTarget(self, action: "skipLogin:", forControlEvents: .TouchUpInside)
        signin.addTarget(self, action: "segueToSignIn:", forControlEvents: .TouchUpInside)
    }
    
    func checkLoginState() {
        if initialLogin {
            segueToContinue(skip)
            initialLogin = false
        }
    }
    
    // check if user has logged in before, continue if they have
    func checkPersistentLogin() {
        let uid = Utils.defaults.stringForKey("uid")
        if uid != nil {
            didSignIn()
            Utils.observeMyBikes(uid!)
            checkLoginState()
        }
    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
        didSignIn()
    }
    
    @IBAction func skipLogin(sender: AnyObject) {
        segueToContinue(skip)
    }
    
    func logout(sender:UIButton) {
        Utils.firebase.unauth()
        didSignOut()
        // reset persistent user information
        Utils.defaults.setObject(nil, forKey: "uid")
        Utils.defaults.setObject(nil, forKey: "myBikesRef")
        Utils.defaults.setObject(nil, forKey: "myBikes")
        // stop observing user's bikes
        BikeInfo.myBikesRef.removeAllObservers()
        BikeInfo.myBikes = [BikeInfo]()
        BikeInfo.myBikesRef = Firebase()
    }
    
    func didSignIn() {
        transformButtons()
        initialLogin = true
    }
    
    func didSignOut() {
        revertButtons()
        initialLogin = false
    }
    
    func segueToContinue(sender: UIButton) {
        performSegueWithIdentifier("continue", sender: self)
    }
    
    func segueToSignUp(sender: UIButton) {
        performSegueWithIdentifier("signUp", sender: self)
    }
    
    func segueToSignIn(sender: UIButton) {
        performSegueWithIdentifier("signIn", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

