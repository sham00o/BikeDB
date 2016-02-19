//
//  BikeTable.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/2/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit
import Foundation

protocol BikeTableDelegate {
    func segueFromBike(index: Int)
    func setType() -> BikeTableType
}

enum BikeTableType {
    case Stolen
    case Registered
}

class BikeTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // Bikes to be displayed
    var bikes = [BikeInfo]()
    
    // Delegate to determine what to do when cell is tapped
    var segueDelegate : BikeTableDelegate?
    
    var type : BikeTableType?

    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        type = segueDelegate?.setType()
        var cell : UITableViewCell!
        if bikes.count > 0 {
            if type == BikeTableType.Registered {
                tableView.registerNib(UINib(nibName: "BikeCell", bundle: nil), forCellReuseIdentifier: "bikeCell")
                cell = tableView.dequeueReusableCellWithIdentifier("bikeCell")
            } else {
                tableView.registerNib(UINib(nibName: "StolenBikeCell", bundle: nil), forCellReuseIdentifier: "stolenBikeCell")
                cell = tableView.dequeueReusableCellWithIdentifier("stolenBikeCell")
            }
        } else {
            tableView.registerNib(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
            cell = tableView.dequeueReusableCellWithIdentifier("emptyCell")
            cell.userInteractionEnabled = false
        }
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there are no bikes, return 1 for empty cell
        return bikes.count == 0 ? 1 : bikes.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return bikes.count == 0 ? 100.0 : 178.0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let bikeCell = cell as? BikeCell {
            bikeCell.loadCellWithBike(bikes[indexPath.row])
        }
        if let bikeCell = cell as? StolenBikeCell {
            bikeCell.loadCellWithBike(bikes[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // segue to report track and send the selected bike
        segueDelegate?.segueFromBike(indexPath.row)
    }

}
