//
//  ReportController.swift
//  BikeDB
//
//  Created by Samuel Liu on 9/28/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ReportController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var pin: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    // Object to manage user's location with CoreLocation
    var locationManager : CLLocationManager!
    // Object to reverse geocode coords into address
    var geocoder : CLGeocoder!
    // Address dictionary
    var addressDict = [String:String]()
    
    // Bike Object
    var bike = BikeInfo()
    
    // Flag to indicate coming from stolen track
    var cameFromStolen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check user's location services settings
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

        geocoder = CLGeocoder()
        pin.image = UIImage(named: "pin")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.configureNavBar(self)
    }

    // MARK: - Location Manager Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as CLLocation!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: false)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Mapview Methods
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        geocoder.reverseGeocodeLocation(loc, completionHandler: {
            (placemarks, error) -> Void in
//            let places = placemarks as? [CLPlacemark]
            if placemarks != nil {
                let place : CLPlacemark = placemarks?[0] as CLPlacemark!
            
                let dict = place.addressDictionary as! [String:NSObject]
                
                self.addressDict["Street"] = dict["Street"] as? String
                self.addressDict["City"] = dict["City"] as? String
                self.addressDict["State"] = dict["State"] as? String
                
                self.lblAddress.text = dict["Street"] as? String
                Utils.activateButton(self.btnNext)

            }
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let dest = segue.destinationViewController as! DetailsController
            dest.dict = addressDict
            dest.bike = bike
            dest.cameFromStolen = cameFromStolen
        }
    }

}
