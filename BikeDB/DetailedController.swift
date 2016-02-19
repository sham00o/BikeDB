//
//  DetailedController.swift
//  BikeDB
//
//  Created by Samuel Liu on 11/25/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class DetailedController: UIViewController {

    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblStyle: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var txtIncident: UITextView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var incidentView: UIView!
    @IBOutlet weak var descriptionStack: UIStackView!
    
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var incHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgCenterX: NSLayoutConstraint!
    
    // Bike object
    var bike : BikeInfo!
    
    var isMainImage = true
    
    var colors = [
        "red":UIColor(red: (215.0/255.0), green: 0.0, blue: (5.0/255.0), alpha: 1.0),
        "orange":UIColor(red: (254.0/255.0), green: (170.0/255.0), blue: (8.0/255.0), alpha: 1.0),
        "yellow":UIColor(red: (244.0/255.0), green: (234.0/255.0), blue: (9.0/255.0), alpha: 1.0),
        "green":UIColor(red: (28.0/255.0), green: (211.0/255.0), blue: (18.0/255.0), alpha: 1.0),
        "blue":UIColor(red: (13.0/255.0), green: (111.0/255.0), blue: (219.0/255.0), alpha: 1.0),
        "purple":UIColor(red: (134.0/255.0), green: 0.0, blue: 1.0, alpha: 1.0),
        "black":UIColor.blackColor(),
        "gray":UIColor(red: (183.0/255.0), green: (183.0/255.0), blue: (183.0/255.0), alpha: 1.0),
        "white":UIColor.whiteColor()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewWithBikeInfo()
        
        let incSize = txtIncident.sizeThatFits(txtIncident.frame.size)
        incHeight.constant = incSize.height
        
        let descSize = txtDescription.sizeThatFits(txtDescription.frame.size)
        descHeight.constant = descSize.height
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if bike.stolen == "true" {
            txtIncident.hidden = false
            incidentView.hidden = false
            scrollHeight.constant = picView.frame.height + descriptionStack.frame.height + incidentView.frame.height + descHeight.constant + incHeight.constant - 10
        } else {
            txtIncident.hidden = true
            incidentView.hidden = true
            scrollHeight.constant = picView.frame.height + descriptionStack.frame.height + descHeight.constant - 10
        }
        
        if bike.color == "white" {
            lblColor.layer.borderColor = UIColor.lightGrayColor().CGColor
            lblColor.layer.borderWidth = 0.5
        }
        lblColor.layer.cornerRadius = 0.5 * lblColor.bounds.size.width
        lblColor.clipsToBounds = true
    }
    
    func loadViewWithBikeInfo() {
        txtIncident.text = bike.incident
        txtDescription.text = bike.features
        lblCity.text = bike.city
        lblState.text = bike.state
        lblDate.text = bike.date
        lblMonth.text = bike.month.uppercaseString
        lblValue.text = "$\(bike.value)"
        lblStyle.text = bike.brand.uppercaseString
        lblType.text = bike.type.uppercaseString
        lblColor.backgroundColor = colors[bike.color]
        let decodedData = NSData(base64EncodedString: bike.secondPic, options: .IgnoreUnknownCharacters)
        let restoredImage = UIImage(data: decodedData!)
        pic.image = restoredImage
    }
    
    @IBAction func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        if bike.mainPic == nil || bike.secondPic == nil { return }
        if recognizer.direction == .Right {
            scrollImages(true)
        }
        if recognizer.direction == .Left {
            scrollImages(false)
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(view)

        imgHeight.constant = translation.y > 0 ? 128 + translation.y : 128
        imgCenterX.constant = translation.x
        
        // when gesture ends
        if recognizer.state == UIGestureRecognizerState.Ended {
            animateBackToSize()
       }
    }
    
    func animateBackToSize() {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .CurveEaseOut, animations: {
            self.imgHeight.constant = 128
            self.imgCenterX.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func scrollImages(toTheRight: Bool) {
        
        let decodedData = isMainImage == true ?
            NSData(base64EncodedString: bike.mainPic, options: .IgnoreUnknownCharacters) :
            NSData(base64EncodedString: bike.secondPic, options: .IgnoreUnknownCharacters)
        
        let restoredImage = UIImage(data: decodedData!)
        isMainImage = !isMainImage
        
        if toTheRight {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
                self.imgCenterX.constant = self.view.frame.width
                self.view.layoutIfNeeded()
                }, completion: {
                    _ -> Void in
                    self.imgCenterX.constant = -self.view.frame.width
                    self.view.layoutIfNeeded()
                    self.pic.image = restoredImage
                    self.animateBackToSize()
            })
        } else {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
                self.imgCenterX.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
                }, completion: {
                    _ -> Void in
                    self.imgCenterX.constant = self.view.frame.width
                    self.view.layoutIfNeeded()
                    self.pic.image = restoredImage
                    self.animateBackToSize()
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
