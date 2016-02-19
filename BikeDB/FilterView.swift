//
//  FilterView.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/7/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    class func instanceFromNib() -> FilterView {
        return UINib(nibName: "FilterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! FilterView
    }
}
