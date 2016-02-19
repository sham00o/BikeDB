//
//  ActivityController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/25/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class ActivityController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableBikes: UITableView!
    
    // Bike object
    var bike : BikeInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableBikes.reloadData()
    }
    
    // MARK: - Table
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if bike.stolen == "true" {
            tableView.registerNib(UINib(nibName: "StolenBikeCell", bundle: nil), forCellReuseIdentifier: "stolenBikeCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("stolenBikeCell") as! StolenBikeCell
        } else {
            tableView.registerNib(UINib(nibName: "BikeCell", bundle: nil), forCellReuseIdentifier: "bikeCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("bikeCell") as! BikeCell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let bikeCell = cell as? BikeCell {
            bikeCell.loadCellWithBike(bike)
        }
        if let bikeCell = cell as? StolenBikeCell {
            bikeCell.loadCellWithBike(bike)
        }
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
