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
private let kScrollThreshold : CGFloat = 100

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pagingScrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var imageScrollView1: ImageScrollView!
    @IBOutlet weak var imageScrollView2: ImageScrollView!
    @IBOutlet weak var imageScrollView3: ImageScrollView!
    @IBOutlet weak var imageScrollView4: ImageScrollView!
    @IBOutlet weak var imageScrollView5: ImageScrollView!

    private var imageScrollViews : [ImageScrollView] = []
    private var initialZoom : CGFloat = 1
    internal var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give button a border
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1
        
        // Track ImageScrollViews in an array
        imageScrollViews.append(imageScrollView1)
        imageScrollViews.append(imageScrollView2)
        imageScrollViews.append(imageScrollView3)
        imageScrollViews.append(imageScrollView4)
        imageScrollViews.append(imageScrollView5)
        
        // Set bounds of pagingScrollView
        var screenSize = UIScreen.mainScreen().bounds.size
        pagingScrollView.contentSize = CGSize(width: screenSize.width * CGFloat(imageScrollViews.count), height: screenSize.height)
        pagingScrollView.delegate = self
        pagingScrollView.contentOffset.x = CGFloat(imageIndex) * screenSize.width
        
        initializeZoomScrollViews()
    }
    
    private func getCurrentImageScrollView() -> ImageScrollView {
        return imageScrollViews[imageIndex]
    }
    
    internal func getImagePosAndZoom() -> (position: CGPoint, zoomScale: CGFloat) {
        var imageScrollView = getCurrentImageScrollView()
        println("offset: \(imageScrollView.contentOffset)")
        println("pos: \(imageScrollView.subviews[0].frame)")
        println("posInView: \(view.convertPoint(imageScrollView.subviews[0].frame.origin, fromCoordinateSpace: imageScrollView))")
        var imageViewOrigin = imageScrollView.subviews[0].frame.origin
        return (view.convertPoint(imageViewOrigin, fromCoordinateSpace: imageScrollView), imageScrollView.zoomScale)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        imageIndex = Int(pagingScrollView.contentOffset.x / UIScreen.mainScreen().bounds.width)
    }
    
    var prevImageIndex = 0
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        prevImageIndex = imageIndex
    }
    
    private func initializeZoomScrollViews() {
        for (i, imageScrollView) in enumerate(imageScrollViews) {
            imageScrollView.backgroundView = backgroundView
            imageScrollView.viewController = self
            imageScrollView.adjustContentInset()
            imageScrollView.contentSize = imageScrollView.bounds.size//imageScrollView.subviews[0].frame.size
        }
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPinchToZoom(pinchGestureRecognizer: UIPinchGestureRecognizer) {
//        var imageScrollView = pinchGestureRecognizer.view?.superview as ImageScrollView
//        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Began) {
//            initialZoom = imageScrollView.zoomScale
//        }
//        imageScrollView.zoomScale = initialZoom * pinchGestureRecognizer.scale
//        println("pinch")
//        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Ended) {
//            imageScrollView.adjustContentInset()
//            println("end")
//        }
    }
}

class ImageScrollView : UIScrollView, UIScrollViewDelegate {
    var backgroundView : UIView!
    var viewController : UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!scrollView.zooming && zoomScale == 1) {
            backgroundView.alpha = max(0, kScrollThreshold - abs(scrollView.contentOffset.y)) / kScrollThreshold * 0.5 + 0.5
        } else {
            backgroundView.alpha = 1
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        (superview as UIScrollView).scrollEnabled = false
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if (zoomScale == 1) {
            (superview as UIScrollView).scrollEnabled = false
            if (abs(scrollView.contentOffset.y) < kScrollThreshold) { // scroll back in place
                setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        (superview as UIScrollView).scrollEnabled = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        adjustContentInset()
        
        if (zoomScale > 1) {
            // Disable paging until zoomed out
            (superview as UIScrollView).scrollEnabled = false
            
            // Allow user to pan in any direction when zoomed in
            directionalLockEnabled = false
        } else {
            // Renable paging
            (superview as UIScrollView).scrollEnabled = true
            
            // Directoin lock when zoomed out
            directionalLockEnabled = true
            
            // I don't understand why, but after over-zooming out, the picture zooms in and then bounces up. This readjusts it
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return subviews[0] as UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var imageView = subviews[0] as UIImageView
        var frameToCenter = imageView.frame
        
        // center horizontally
        if (frameToCenter.size.width < bounds.width) {
            frameToCenter.origin.x = (bounds.width - frameToCenter.width) / 2
            contentSize.width = bounds.width
        } else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if (frameToCenter.size.height < bounds.height) {
            frameToCenter.origin.y = (bounds.height - frameToCenter.height) / 2
            contentSize.height = bounds.height
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
        
    }
    
    private func adjustContentInset() {
        if (zoomScale >  1) { // Zoomed in
            contentInset.bottom = 0
            contentInset.top = 0
        } else { // Zoomed all the way out
            contentInset.bottom = bounds.height
            contentInset.top = bounds.height
        }
    }
}