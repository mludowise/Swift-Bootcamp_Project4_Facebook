//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Mel Ludowise on 10/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

let kPhotoViewSegueID = "photoViewSegue"
let kPhotoViewControllerID = "photoViewController"

class PhotoViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    internal var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give button a border
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1
        
        imageView.image = image
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
