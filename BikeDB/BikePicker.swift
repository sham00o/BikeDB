//
//  BikePicker.swift
//  BikeDB
//
//  Created by Samuel Liu on 2/7/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

protocol BikePickerDelegate {
    func textFieldToSet() -> UITextField
}

class BikePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var bikeDelegate : BikePickerDelegate!
    
    let bikeTypes = [ "COMFORT", "CRUISER", "FIXIE", "HYBRID", "MOUNTAIN", "MOTOR", "ROAD", "TANDEM", "TOUR"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        delegate = self
        dataSource = self
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textField = bikeDelegate?.textFieldToSet()
        textField!.text = bikeTypes[row].uppercaseString
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bikeTypes[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bikeTypes.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

}
