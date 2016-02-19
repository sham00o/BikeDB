//
//  Utils.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/24/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Utils {
    
    // reference to firebase for Firebase API calls
    static let firebase = Firebase(url: "burning-inferno-5216.firebaseio.com")
    // reference to bikes in Firebase
    static let bikesRef = firebase.childByAppendingPath("bikes")
    // reference to user defaults for account persistence
    static let defaults = NSUserDefaults.standardUserDefaults()
    // reference to notification center for tables listening to reload
    static let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // default color
    static let defaultColor = UIColor(red: (4.0/255.0), green: (142.0/255.0), blue: (188.0/255.0), alpha: 1.0)
    
    //
    // This is a series of functions that are used commonly throughout the app
    //

    
    // Observe bikes matching @param uid in Firebase and save them for application use
    static func observeMyBikes(uid: String) {
        bikesRef.queryOrderedByChild("uid").queryEqualToValue(uid).observeEventType(FEventType.Value, withBlock: {
            (snapshot) -> Void in
            // save Firebase reference and this user's bikes
            BikeInfo.myBikesRef = snapshot.ref
            BikeInfo.myBikes = Utils.snapshotToBikeInfo(snapshot)
            
            // notify observers that bikes have been updated
            self.notificationCenter.postNotificationName("updatedBikes", object: nil)
            
            // archive bikes for next session
//            archive(BikeInfo.myBikes, key: "myBikes")
//            archive(BikeInfo.myBikesRef, key: "myBikesRef")
            print("\(BikeInfo.myBikes.count) bikes found")
            }, withCancelBlock: {
                (error) -> Void in
                print("error: \(error.description)")
        })
    }
    
    // Observe bikes where child key "stolen" is true and save them for quicker reference
    static func observeStolenBikes() {
        bikesRef.queryOrderedByChild("stolen").queryEqualToValue("true").observeEventType(FEventType.Value, withBlock: {
            (snapshot) -> Void in
            // save Firebase reference and this user's bikes
            print(snapshot.ref)
            BikeInfo.stolenBikes = Utils.snapshotToBikeInfo(snapshot)
            
            // notify observers that bikes have been updated
            self.notificationCenter.postNotificationName("updatedStolenBikes", object: nil)
            
            // archive stolen bikes for next session
//            archive(BikeInfo.stolenBikes, key: "stolenBikes")
            print("\(BikeInfo.stolenBikes.count) bikes found")
            }, withCancelBlock: {
                (error) -> Void in
                print("error: \(error.description)")
        })
    }
    
    // Parse snapshot from firebase into bike info
    static func snapshotToBikeInfo(snapshot: FDataSnapshot) -> [BikeInfo] {
        var bikes = [BikeInfo]()
        
        for child in snapshot.children {
            let bike = child as! FDataSnapshot
            bikes.append(BikeInfo(ref: bike.ref,
                ti: bike.value["time"] as! String,
                inc: bike.value["description"] as! String,
                addr: bike.value["address"] as! String,
                sto: bike.value["stolen"] as! String,
                n: bike.value["name"] as! String,
                u: bike.value["uid"] as! String,
                m: bike.value["month"] as! String,
                ci: bike.value["city"] as! String,
                d: bike.value["date"] as! String,
                st: bike.value["state"] as! String,
                b: bike.value["brand"] as! String,
                t: bike.value["type"] as! String,
                c: bike.value["color"] as! String,
                s: bike.value["serial"] as! String,
                si: bike.value["second_pic"] as! String,
                se: bike.value["main_pic"] as! String,
                v: bike.value["value"] as! String,
                f: bike.value["features"] as! String))
        }
        return bikes
    }
    
    // Add @param bike to Firebase/bikes
    static func addBikeToFirebase(bike: BikeInfo) {
        bike.reference = firebase.childByAppendingPath("bikes").childByAppendingPath(bike.serial)
        let bikeJSON = ["time":bike.time,
            "description":bike.incident,
            "address":bike.address,
            "month":bike.month,
            "city":bike.city,
            "date":bike.date,
            "state":bike.state,
            "uid":defaults.valueForKey("uid") as! String,
            "name":bike.name,
            "brand":bike.brand,
            "type":bike.type,
            "color":bike.color,
            "serial":bike.serial,
            "second_pic":bike.secondPic,
            "main_pic":bike.mainPic,
            "stolen":bike.stolen,
            "value":bike.value,
            "features":bike.features]
        
        bike.reference.setValue(bikeJSON)
    }

    // Scale image down to new size while maintaining aspect ratio
    static func scaleImage(img: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor : CGFloat
        
        if img.size.width > img.size.height {
            // landscape image
            print(img.size.height)
            print(img.size.width)
            scaleFactor = img.size.height/img.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaleFactor * scaledSize.width
        } else {
            // portrait image
            scaleFactor = img.size.width / img.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaleFactor * scaledSize.height
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        img.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImg = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImg
    }
    
    // Create a simple alert controller with title and msg
    // parameters and dismiss button
    static func alertUser(title: String, msg: String, handle: (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Default, handler: handle)
        alert.addAction(dismiss)
        
        return alert
    }
    
    // Run a closure after a delay number of seconds
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // Configure a view controllers navigation bar for the default style
    // This should be used when going to and from HomeController
    static func configureNavBar(vc: UIViewController) {
        vc.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        vc.navigationController?.navigationBar.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        vc.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20)!]
        vc.navigationController!.navigationBar.barStyle = UIBarStyle.Default
        vc.navigationController?.navigationBar.shadowImage = UIImage(named: " ")
        vc.navigationController?.navigationBar.tintColor = defaultColor
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    // Change the appearance of the button to reflect status
    static func activateButton(btn: UIButton) {
        btn.backgroundColor = defaultColor
//        btn.backgroundColor = UIColor(red: 81/255.0, green: 190/255.0, blue: 224/255.0, alpha: 1.0)
        btn.tintColor = UIColor.whiteColor()
    }
    
    // Revert button to appear inactive
    static func deactivateButton(btn: UIButton) {
        btn.backgroundColor = UIColor.lightGrayColor()
        btn.tintColor = UIColor.whiteColor()
    }
    
}