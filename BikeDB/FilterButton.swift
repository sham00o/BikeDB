//
//  FilterButton.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/7/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
    
    var chosen = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 0.05 * bounds.size.width
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 0.5
        
        addTarget(self, action: "highlight:", forControlEvents: .TouchUpInside)
    }
    
    func highlight(sender: AnyObject?) {
        if chosen {
            chosen = false
            backgroundColor = UIColor.clearColor()
            for ind in 0...BikeInfo.filters.count-1 {
                if BikeInfo.filters[ind] == self.titleLabel!.text! {
                    BikeInfo.filters.removeAtIndex(ind)
                    break
                }
            }
        } else {
            chosen = true
            backgroundColor = Utils.defaultColor
            BikeInfo.filters.append(self.titleLabel!.text!)
        }
    }

}
