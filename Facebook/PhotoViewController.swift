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
    
    private var initialZoom : CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Give button a border
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1
        
        imageView.image = image
        
        adjustScrollContentBounds()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.zoomScale <= 1) {
            backgroundView.alpha = max(0, kScrollThreshold - abs(scrollView.contentOffset.y)) / kScrollThreshold * 0.5
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if (scrollView.zoomScale <= 1) {
            if (abs(scrollView.contentOffset.y) < kScrollThreshold) { // scroll back in place
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    
    private func adjustScrollContentBounds() {
        if (scrollView.zoomScale >  1) { // Zoomed in
            scrollView.contentSize = imageView.frame.size
            scrollView.contentInset.bottom = 0
            scrollView.contentInset.top = 0
        } else { // Zoomed all the way out
            var screenSize = UIScreen.mainScreen().bounds
            scrollView.contentSize = screenSize.size
            scrollView.contentInset.bottom = screenSize.height
            scrollView.contentInset.top = screenSize.height
        }
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPinchToZoom(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Began) {
            initialZoom = scrollView.zoomScale
        }
        scrollView.zoomScale = initialZoom * pinchGestureRecognizer.scale
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            adjustScrollContentBounds()
        }
    }
}
