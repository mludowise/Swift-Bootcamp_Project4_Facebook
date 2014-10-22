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
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!

    private var initialZoom : CGFloat = 1
    internal var imageIndex = 0
    
    private var imageViews : [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give button a border
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1

        imageViews.append(imageView1)
        imageViews.append(imageView2)
        imageViews.append(imageView3)
        imageViews.append(imageView4)
        imageViews.append(imageView5)
        
        // Adjust for screensize
        adjustImagesForScreensize()
        
        // Adjust scroll view & set delegate
        scrollView.delegate = self
        adjustScrollSettings()
        
        // Initialize for selected image
        scrollView.contentOffset.x = CGFloat(imageIndex) * UIScreen.mainScreen().bounds.width
    }
    
    internal func getImageOffsetAndZoom() -> (zoomScale: CGFloat, offset: CGPoint) {
        var offsetX = scrollView.contentOffset.x - UIScreen.mainScreen().bounds.width * CGFloat(getImageIndexFromScrollPos())
        var offsetPoint = CGPoint(x: offsetX, y: scrollView.contentOffset.y)
        return (scrollView.zoomScale, offsetPoint)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.zoomScale <= 1) {
            backgroundView.alpha = max(0, kScrollThreshold - abs(scrollView.contentOffset.y)) / kScrollThreshold * 0.5
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if (scrollView.zoomScale <= 1) {
            // Update the image index after paging
            imageIndex = getImageIndexFromScrollPos()
            
            if (abs(scrollView.contentOffset.y) < kScrollThreshold) { // scroll back in place
                var offset = CGPoint(x: scrollView.contentOffset.x, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            } else {
                // Have to do turn off paging before dismissing modal or animation gets messed up
                scrollView.pagingEnabled = false
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
//        println("image\(getIndexFromImageView(getImageView()!))")
        return getImageView()
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPinchToZoom(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        println("pinchScale: \(pinchGestureRecognizer.scale) zoomScale:\(scrollView.zoomScale)")
        println(scrollView.contentOffset)
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Began) {
            initialZoom = scrollView.zoomScale
            println(imageIndex)
        }
        scrollView.zoomScale = initialZoom * pinchGestureRecognizer.scale
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            adjustScrollSettings()
        }
    }
    
    private func adjustScrollSettings() {
        var screenSize = UIScreen.mainScreen().bounds
        if (scrollView.zoomScale >  1) { // Zoomed in
            scrollView.pagingEnabled = false
            scrollView.contentSize = getImageView()!.frame.size
            scrollView.contentInset.bottom = 0
            scrollView.contentInset.top = 0
        } else { // Zoomed all the way out
            scrollView.pagingEnabled = true
            scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(imageViews.count), height: screenSize.height)
            scrollView.contentInset.bottom = screenSize.height
            scrollView.contentInset.top = screenSize.height
        }
    }
    
    private func adjustImagesForScreensize() {
        var screenBounds = UIScreen.mainScreen().bounds
        for (i, imageView) in enumerate(imageViews) {
//            imageView.frame.size = screenBounds.size
            resizeAndRepositionImageToAspectFit(imageView, screenBounds)
            imageView.frame.origin.x = CGFloat(i) * screenBounds.width
        }
    }
    
    private func getImageIndexFromScrollPos() -> Int {
        return Int(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.width)
    }
    
    internal func getImage() -> UIImage? {
        return getImageView()?.image
    }
    
    private func getImageView() -> UIImageView? {
        return getImageViewFromIndex(imageIndex)
    }
    
    private func getIndexFromImageView(imageView: UIImageView) -> Int? {
        return find(imageViews, imageView)?
    }
    
    private func getImageViewFromIndex(index: Int) -> UIImageView? {
        if (index >= imageViews.count) {
            return nil
        }
        return imageViews[index]
    }
}
