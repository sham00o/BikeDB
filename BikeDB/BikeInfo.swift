//
//  BikeInfo.swift
//  BikeDB
//
//  Created by Samuel Liu on 10/5/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BikeInfo {
    
    //
    // Object to hold information of a particular bike that we will save or load from firebase
    //
    
    static var myBikes = [BikeInfo]()
    static var myBikesRef = Firebase()
    static var stolenBikes = [BikeInfo]()
    static var filters = [String]()
    
    // Applies @param filters to return matching bikes from @param bikes
    // returns all bikes if no filters
    static func filterStolenBikes() -> [BikeInfo] {
        if filters.count == 0 { return stolenBikes }
        var filteredBikes = [BikeInfo]()
        for filter in filters {
            print(filter)
            var temp = [BikeInfo]()
            // COLOR FILTER
            if filter == "Red" || filter == "Orange" || filter == "Yellow" || filter == "Green" || filter == "Blue" || filter == "Purple" || filter == "Black" || filter == "Gray" || filter == "White" {
                for bike in stolenBikes {
                    var skip = false
                    for filtered in filteredBikes {
                        if bike.serial == filtered.serial {
                            skip = true
                            break
                        }
                    }
                    if bike.color.uppercaseString == filter.uppercaseString && skip == false {
                        temp.append(bike)
                    }
                }
            }
            // transfer to filtered bikes
            for addition in temp {
                filteredBikes.append(addition)
            }
            temp = [BikeInfo]()
            // TYPE FILTER
            if filter == "Comfort" || filter == "Cruiser" || filter == "Fixie" || filter == "Hybrid" || filter == "Mountain" || filter == "Motor" || filter == "Road" || filter == "Tandem" || filter == "Tour" {
                for bike in stolenBikes {
                    var skip = false
                    for filtered in filteredBikes {
                        if bike.serial == filtered.serial {
                            skip = true
                            break
                        }
                    }
                    if bike.type.uppercaseString == filter.uppercaseString && skip == false {
                        temp.append(bike)
                    }
                }
            }
            // transfer to filtered bikes
            for addition in temp {
                filteredBikes.append(addition)
            }
        }
        return filteredBikes
    }
    
    var reference : Firebase!
    var address : String!
    var name : String!
    var uid : String!
    var brand : String!
    var type : String!
    var color : String!
    var serial : String!
    var secondPic : String!
    var mainPic : String!
    var value : String!
    var features : String!
    var city : String!
    var state : String!
    var date : String!
    var month : String!
    var time : String!
    var incident : String!
    var stolen : String!
    
    init() {
        reference = nil
        address = ""
        name = ""
        uid = ""
        brand = ""
        type = ""
        color = ""
        serial = ""
        secondPic = ""
        mainPic = ""
        value = ""
        features = ""
        city = ""
        state = ""
        date = ""
        month = ""
        time = ""
        incident = ""
        stolen = "false"
    }
    
    init(ref: Firebase, ti:String, inc:String, addr:String, sto:String, n:String, u:String, m:String, ci:String, d:String, st:String, b:String, t:String, c:String, s:String, si:String, se:String, v:String, f:String) {
        reference = ref
        address = addr
        time = ti
        incident = inc
        stolen = sto
        name = n
        uid = u
        month = m
        city = ci
        date = d
        state = st
        brand = b
        type = t
        color = c
        serial = s
        secondPic = si
        mainPic = se
        value = v
        features = f
    }
    
    func setFields(addr:String, ci:String, st:String, da:String, mo:String, ti:String, inc:String){
        address = addr
        city = ci
        state = st
        date = da
        month = mo
        time = ti
        incident = inc
    }
    
    func setStolen() {
        stolen = "true"
    }
}