//
//  BikeCell.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/20/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class BikeCell: UITableViewCell {
        
    @IBOutlet weak var pic : UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func loadCellWithBike(bike: BikeInfo) {
        decodePic(bike.mainPic)
        name.text = bike.name
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
