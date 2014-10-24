//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedView: UIImageView!
    
    @IBOutlet weak var thumbnailImageView1: UIImageView!
    @IBOutlet weak var thumbnailImageView2: UIImageView!
    @IBOutlet weak var thumbnailImageView3: UIImageView!
    @IBOutlet weak var thumbnailImageView4: UIImageView!
    @IBOutlet weak var thumbnailImageView5: UIImageView!
    
    private let kTransitionDuration = 0.4
    private var isPresenting: Bool = true
    
    private var thumbnailImageViews : [UIImageView] = []
    private var transitionImageView = UIImageView()
    private var imageBackgroundView = UIView(frame: UIScreen.mainScreen().bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
        thumbnailImageViews.append(thumbnailImageView1)
        thumbnailImageViews.append(thumbnailImageView2)
        thumbnailImageViews.append(thumbnailImageView3)
        thumbnailImageViews.append(thumbnailImageView4)
        thumbnailImageViews.append(thumbnailImageView5)
        
        imageBackgroundView.backgroundColor = UIColor.blackColor()
        transitionImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.startAnimating()
        delay(2, { () -> () in
            self.activityIndicator.stopAnimating()
            self.feedView.alpha = 1
        })
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return kTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        
        var photoViewController = isPresenting ?
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as PhotoViewController :
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as PhotoViewController
        
        var thumbnailImageView = thumbnailImageViews[photoViewController.imageIndex]
        var thumbnailFrame = getResizedFrameFromAspectFill(thumbnailImageView.image!, thumbnailImageView.frame)
        thumbnailFrame.origin = view.convertPoint(thumbnailFrame.origin, fromView: thumbnailImageView.superview)
        transitionImageView.image = thumbnailImageView.image
        
        if (isPresenting) {
            // Set background to transparent
            imageBackgroundView.alpha = 0
            
            // Set image frame to thumbnail
            transitionImageView.frame = thumbnailFrame
            
            // Add them both to our view
            view.addSubview(imageBackgroundView)
            view.addSubview(transitionImageView)
            
            // Animate
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                // Set background to opaque
                self.imageBackgroundView.alpha = 1
                
                // Set image frame to that of the resulting view
                self.transitionImageView.frame = getResizedFrameFromAspectFit(self.transitionImageView.image!, UIScreen.mainScreen().bounds)
                }) { (finished: Bool) -> Void in
                    self.imageBackgroundView.hidden = true
                    self.transitionImageView.hidden = true
                    containerView.addSubview(photoViewController.view)
                    transitionContext.completeTransition(true)
            }
        } else {
            photoViewController.view.removeFromSuperview()
            transitionImageView.frame = getResizedFrameFromAspectFit(transitionImageView.image!, UIScreen.mainScreen().bounds)

            imageBackgroundView.hidden = false
            transitionImageView.hidden = false
            
            // Take into consideration the position insize the scrollView of the photo in the PhotoViewController
            transitionImageView.frame = photoViewController.getImageFrame()
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                self.imageBackgroundView.alpha = 0
                self.transitionImageView.frame = thumbnailFrame
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    self.imageBackgroundView.removeFromSuperview()
                    self.transitionImageView.removeFromSuperview()
            }
        }
    }

    @IBAction func onThumbnailTap1(sender: UITapGestureRecognizer) {
        onThumbnailTap(sender, imageIndex: 0)
    }
    
    @IBAction func onThumbnailTap2(sender: UITapGestureRecognizer) {
        onThumbnailTap(sender, imageIndex: 1)
    }
    
    @IBAction func onThumbnailTap3(sender: UITapGestureRecognizer) {
        onThumbnailTap(sender, imageIndex: 2)
    }
    
    @IBAction func onThumbnailTap4(sender: UITapGestureRecognizer) {
        onThumbnailTap(sender, imageIndex: 3)
    }
    
    @IBAction func onThumbnailTap5(sender: UITapGestureRecognizer) {
        onThumbnailTap(sender, imageIndex: 4)
    }
    
    func onThumbnailTap(sender: UITapGestureRecognizer, imageIndex: Int) {
        var photoViewController = storyboard?.instantiateViewControllerWithIdentifier(kPhotoViewControllerID) as PhotoViewController
        photoViewController.imageIndex = imageIndex
        photoViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        photoViewController.transitioningDelegate = self
        presentViewController(photoViewController, animated: true, completion: nil)
    }
}