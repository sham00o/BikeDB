//
//  StartController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/28/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Firebase

class NewsController: UIViewController, BikeTableDelegate, ToolbarDelegate {

    let firebase = Firebase(url: "burning-inferno-5216.firebaseio.com")
    
    // variables for showing FilterView
    var filterAdded = false
    var filterView : FilterView!
    var blur : UIVisualEffectView!
    var toolbar : Toolbar!
        
    @IBOutlet weak var tableBikes: BikeTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableBikes.segueDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.notificationCenter.addObserver(self, selector: "updateBikes:", name: "updatedStolenBikes", object: nil)
        Utils.configureNavBar(self)
        Utils.observeStolenBikes()
        tabBarController?.title = "Save the Bike"
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "showFilterOptions:")
        tabBarController!.navigationItem.rightBarButtonItem = filterButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController!.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLayoutSubviews() {
        setupFilter()
        tableBikes.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func updateBikes(notification: NSNotification) {
        tableBikes.bikes = BikeInfo.stolenBikes
        tableBikes.reloadData()
        removeFilter()
    }
    
    @IBAction func showFilterOptions(sender: AnyObject) {
        if filterAdded == false {
            filterAdded = true
            view.addSubview(blur)
            view.addSubview(filterView)
            view.addSubview(toolbar)
            blur.hidden = true
            filterView.hidden = true
            toolbar.hidden = true
        }
        for sub in view.subviews {
            if sub is FilterView {
                sub.hidden = !sub.hidden
            }
            if sub is UIVisualEffectView {
                sub.hidden = !sub.hidden
            }
            if sub is UIToolbar {
                tabBarController?.tabBar.hidden = sub.hidden
                sub.hidden = !sub.hidden
            }
        }
        tableBikes.bikes = BikeInfo.filterStolenBikes()
        tableBikes.reloadData()
    }
    
    func removeFilter() {
        filterAdded = false
        for sub in view.subviews {
            if sub is FilterView {
                sub.removeFromSuperview()
            }
            if sub is UIVisualEffectView {
                sub.removeFromSuperview()
            }
            if sub is UIToolbar {
                tabBarController?.tabBar.hidden = false
                sub.removeFromSuperview()
            }
        }
        BikeInfo.filters = [String]()
    }
    
    func setupFilter() {
        toolbar = Toolbar.instanceFromNib()
        toolbar.clearDelegate = self
        var toolbarBounds = view.bounds
        toolbarBounds.size.height = (tabBarController?.tabBar.frame.height)!
        let offset = (tabBarController?.tabBar.frame.height)! - toolbar.frame.size.height
        toolbarBounds.origin.y = (tabBarController?.tabBar.frame.origin.y)! + offset
        toolbar.frame = toolbarBounds
        toolbar.sizeToFit()
        
        blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        var viewBounds = view.bounds
        let topOffset = topLayoutGuide.length
        viewBounds.origin.y += topOffset
        viewBounds.size.height -= (topOffset+bottomLayoutGuide.length-offset)
        blur.frame = viewBounds
        filterView = FilterView.instanceFromNib()
        filterView.frame = viewBounds
    }
    
    func clearAll() {
        removeFilter()
    }
    
    func segueFromBike(index: Int) {
        performSegueWithIdentifier("preview", sender: tableBikes.bikes[index])
    }
    
    func setType() -> BikeTableType {
        return BikeTableType.Stolen
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "preview" {
            let dest = segue.destinationViewController as! DetailedController
            dest.bike = sender as! BikeInfo
        }
    }

}
