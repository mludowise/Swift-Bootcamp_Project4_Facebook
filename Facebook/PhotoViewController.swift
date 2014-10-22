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
    
    internal func getImageOffsetAndZoom() -> (zoomScale: CGFloat, offset: CGPoint) {
        var imageScrollView = getCurrentImageScrollView()
        return (imageScrollView.zoomScale, imageScrollView.contentOffset)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        imageIndex = Int(pagingScrollView.contentOffset.x / UIScreen.mainScreen().bounds.width)
    }
    
    private func initializeZoomScrollViews() {
        for (i, imageScrollView) in enumerate(imageScrollViews) {
            imageScrollView.backgroundView = backgroundView
            imageScrollView.viewController = self
            imageScrollView.adjustScrollContentBounds()
            imageScrollView.contentSize = imageScrollView.subviews[0].frame.size
        }
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPinchToZoom(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        var imageScrollView = pinchGestureRecognizer.view?.superview as ImageScrollView
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Began) {
            initialZoom = imageScrollView.zoomScale
        }
        imageScrollView.zoomScale = initialZoom * pinchGestureRecognizer.scale
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            imageScrollView.adjustScrollContentBounds()
        }
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
        if (scrollView.zoomScale <= 1) {
            backgroundView.alpha = max(0, kScrollThreshold - abs(scrollView.contentOffset.y)) / kScrollThreshold * 0.5
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if (scrollView.zoomScale <= 1) {
            if (abs(scrollView.contentOffset.y) < kScrollThreshold) { // scroll back in place
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return subviews[0] as UIView
    }
    
    func adjustScrollContentBounds() {
        if (zoomScale >  1) { // Zoomed in
            contentSize = subviews[0].frame.size
            contentInset.bottom = 0
            contentInset.top = 0
        } else { // Zoomed all the way out
            var screenSize = UIScreen.mainScreen().bounds
            contentSize = screenSize.size
            contentInset.bottom = screenSize.height
            contentInset.top = screenSize.height
        }
    }
}