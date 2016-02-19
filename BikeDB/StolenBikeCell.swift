//
//  StolenBikeCell.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/4/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class StolenBikeCell: UITableViewCell {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    func loadCellWithBike(bike: BikeInfo) {
        decodePic(bike.mainPic)
        lblCity.text = bike.city
        lblState.text = bike.state.uppercaseString
        lblDate.text = bike.date
        lblMonth.text = bike.month.uppercaseString
        lblPrice.text = "$\(bike.value)"
    }
    
    func decodePic(data: String) {
        let decodedData = NSData(base64EncodedString: data, options: .IgnoreUnknownCharacters)
        let restoredImage = UIImage(data: decodedData!)
        pic.image = restoredImage
        backgroundColor = UIColor.clearColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
