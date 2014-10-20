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

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    private let kScrollThreshold : CGFloat = 100
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    internal var image : UIImage?
    
    internal var pinchGestureRecognizer = UIPinchGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Give button a border
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1
        
        imageView.image = image
        pinchGestureRecognizer.addTarget(self, action: Selector("onPinchToZoom"))
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        var screenSize = UIScreen.mainScreen().bounds
        scrollView.contentInset.bottom = screenSize.height
        scrollView.contentInset.top = screenSize.height
        scrollView.contentSize = screenSize.size
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        backgroundView.alpha = max(0, kScrollThreshold - abs(scrollView.contentOffset.y)) / kScrollThreshold * 0.5
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        println(scrollView.contentOffset.y)
        if (abs(scrollView.contentOffset.y) < kScrollThreshold) { // scroll back in place
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBAction func onPinchToZoom(pinchGestureRecognizer: UIPinchGestureRecognizer) {
    func onPinchToZoom() {
        println("pinch")
        scrollView.zoomScale = pinchGestureRecognizer.scale
    }
}
