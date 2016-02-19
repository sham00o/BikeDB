//
//  Toolbar.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/8/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

protocol ToolbarDelegate {
    func clearAll()
}

class Toolbar: UIToolbar {
    
    var clearDelegate : ToolbarDelegate?

    @IBOutlet weak var text: UIBarButtonItem!
    @IBOutlet weak var clear: UIBarButtonItem!
    
    class func instanceFromNib() -> Toolbar {
        let toolbar = UINib(nibName: "Toolbar", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! Toolbar
        toolbar.setup()
        
        return toolbar
    }
    
    func setup() {
        text.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12.0)], forState: .Normal)
    }

    @IBAction func clearAll(sender: AnyObject) {
        clearDelegate?.clearAll()
    }
}
