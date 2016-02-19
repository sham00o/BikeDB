//
//  HomeController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    // This is the main view after logging in for the user to choose what he wants to do in our app
    //

    let options = ["Register a bike",
        "My bike was stolen",
        "See if a bike was stolen",
        "I witnessed a bicycle crime",
        "Start using the app"]
    
    let homeCellIdentifier = "HomeCell"
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bike.jpg")!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
    }

    override func viewDidLayoutSubviews() {
        configureTable()
    }
    
    func configureTable() {
        tableView.layer.cornerRadius = 50.0
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
    
    // MARK: - Table Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.height/5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("performing segue: \(options[indexPath.row])")
        switch options[indexPath.row] {
            case "Register a bike":
                performSegueWithIdentifier("register", sender: self)
            break
            case "My bike was stolen":
                performSegueWithIdentifier("stolen", sender: self)
            break
            case "See if a bike was stolen":
                performSegueWithIdentifier("find", sender: self)
            break
            case "I witnessed a bicycle crime":
                performSegueWithIdentifier("report", sender: self)
            break
        default:
            performSegueWithIdentifier("start", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(homeCellIdentifier) as! HomeCell
        
        configureCell(cell, index: indexPath)
        
        return cell
    }
    
    func configureCell(cell: HomeCell, index: NSIndexPath) {
        cell.title.text = options[index.row]
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        // do something
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "register" {
            let dest = segue.destinationViewController as! BikesController
            dest.heading = "Register a bike"
        }
        if segue.identifier == "stolen" {
            let dest = segue.destinationViewController as! BikesController
            dest.heading = "Which bike was stolen?"
            dest.cameFromStolen = true
        }
    }

}

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pic: UIImageView!
}
