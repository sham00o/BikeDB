//
//  RegisterPhotoController.swift
//  BikeDB
//
//  Created by Samuel Liu on 10/5/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class RegisterPhotoController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //
    // The purpose of this controller is for the user to take pictures of the bike and his/her self to be put passed into the database
    //

    @IBOutlet weak var sideImage: UIImageView!
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var sideButton: UIButton!
    @IBOutlet weak var selfButton: UIButton!
    @IBOutlet weak var sideRemove: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Bike information object to collect from views
    var bike : BikeInfo!
    
    // Flag to indicate if coming from stolen
    var cameFromStolen = false
    
    // Tap to view image
    var tapViewSide : UITapGestureRecognizer!
    var tapViewSelf : UITapGestureRecognizer!
    // Tap to revert image
    var dismissFullscreen : UITapGestureRecognizer!
    
    // string to hold image data for side image of bike
    var sideData = ""
    // string to hold image data for user's self image of bike
    var selfData = ""
    
    let screenBounds = UIScreen.mainScreen().bounds
    var selectedImage : UIImageView!
    var selectedSelf = false
    var selectedSide = false
    var buttonActivated = false
    var viewIndex : Int!
    var prevFrame : CGRect!
    var selectingSideImage = true // true is set to SIDE, false is for SELF
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapViewSide = UITapGestureRecognizer(target: self, action: Selector("viewImage:"))
        tapViewSelf = UITapGestureRecognizer(target: self, action: Selector("viewImage:"))
        dismissFullscreen = UITapGestureRecognizer(target: self, action: Selector("revertImage"))
        
        sideImage.addGestureRecognizer(tapViewSide)
        selfImage.addGestureRecognizer(tapViewSelf)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: selfImage.frame.size.height + sideImage.frame.size.height + CGFloat(50.0))
    }

    @IBAction func addPhoto(sender: UIButton) {
        if sender == sideButton {
            selectingSideImage = true
            selectedSide = true
        } else {
            selectingSideImage = false
            selectedSelf = true
        }
        
        chooseImageSource()
    }
    
    @IBAction func removePhoto(sender: UIButton) {
        if sender == sideRemove {
            sideImage.image = UIImage()
            sideImage.backgroundColor = UIColor.whiteColor()
            sideButton.hidden = false
            selectedSide = false
        } else {
            selfImage.image = UIImage()
            selfImage.backgroundColor = UIColor.whiteColor()
            selfButton.hidden = false
            selectedSelf = false
        }
        checkFields()
    }
    
    // Present a dialog for the user to choose a photo from library or to take a new one with camera
    func chooseImageSource() {
        let alert = UIAlertController(title: "Choose a source", message: nil, preferredStyle: .ActionSheet)
        
        let camera = UIAlertAction(title: "Take a photo", style: .Default, handler: { (action) -> Void in
            self.showPicker(.Camera)
        })
        let library = UIAlertAction(title: "Choose from library", style: .Default, handler: { (action) -> Void in
            self.showPicker(.PhotoLibrary)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func showPicker(source: UIImagePickerControllerSourceType) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func viewImage(sender: UITapGestureRecognizer) {
        if sender == tapViewSide {
            selectedImage = sideImage
            selectedImage.removeGestureRecognizer(tapViewSide)
        } else {
            selectedImage = selfImage
            selectedImage.removeGestureRecognizer(tapViewSelf)
        }
        UIView.animateWithDuration(0.5, animations: {
            self.prevFrame = self.selectedImage.frame
            let ratio = self.prevFrame.height/self.prevFrame.width
            let height = ratio*self.screenBounds.width
            let newFrame = CGRect(x: 0, y: (self.screenBounds.height/2)-(height/2), width: self.screenBounds.width, height: height)
            self.selectedImage.frame = newFrame
            }, completion: nil)
        hideAllExcept(selectedImage)
        view.addGestureRecognizer(dismissFullscreen)
    }
    
    func revertImage() {
        UIView.animateWithDuration(0.5, animations: {
            self.selectedImage.frame = self.prevFrame
            }, completion: {
                (finished: Bool) -> Void in
                self.unHideAll()
        })
        view.removeGestureRecognizer(self.dismissFullscreen)
        sideImage.addGestureRecognizer(tapViewSide)
        selfImage.addGestureRecognizer(tapViewSelf)
    }
    
    func checkFields() {
        if selectedSelf {
            Utils.activateButton(btnNext)
            btnNext.addTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        } else {
            Utils.deactivateButton(btnNext)
            btnNext.removeTarget(self, action: "segue:", forControlEvents: .TouchUpInside)
        }
    }
    
    func getImageDataString(img: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(img)
        return (imgData?.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn))!
    }
    
    func hideAllExcept(view: UIView) {
        let views = view.superview?.subviews
        for v in views! {
            v.hidden = true
        }
        view.hidden = false
    }
    
    func unHideAll() {
        let views = super.view.subviews
        for v in views {
            v.hidden = false
        }
        if selectedSide {
            sideButton.hidden = true
        }
        if selectedSelf {
            selfButton.hidden = true
        }
    }
    
    // if coming from "Describe the Incident" flow, segue to Review Controller, else continue Register flow
    func segue(sender: AnyObject) {
        bike.secondPic = sideData
        bike.mainPic = selfData
        if navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] is DetailsController {
            performSegueWithIdentifier("review", sender: self)
        } else {
            performSegueWithIdentifier("next", sender: self)
        }
    }
    
    // MARK: - Image Picker methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // encode compressed image
        let smallerImg = Utils.scaleImage(image!, maxDimension: 600)
        
        if selectingSideImage {
            sideImage.image = smallerImg
            sideImage.contentMode = .ScaleAspectFit
            sideImage.backgroundColor = UIColor.blackColor()
            selectingSideImage = false
            sideButton.hidden = true
            sideData = getImageDataString(smallerImg)
        } else {
            selfImage.image = smallerImg
            selfImage.contentMode = .ScaleAspectFit
            selfImage.backgroundColor = UIColor.blackColor()
            selfButton.hidden = true
            selfData = getImageDataString(smallerImg)

        }
        checkFields()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "next" {
            let dest = segue.destinationViewController as! RegisterInfoController
            // automatically set the bike as stolen if coming from the stolen track
            dest.cameFromStolen = cameFromStolen
            dest.bike = bike
        }
        if segue.identifier == "review" {
            let dest = segue.destinationViewController as! ReviewController
            dest.bike = bike
        }
    }

}
