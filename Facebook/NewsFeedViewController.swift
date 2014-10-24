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
    
    @IBOutlet weak var thumbnailImageView1: UIImageView!
    @IBOutlet weak var thumbnailImageView2: UIImageView!
    @IBOutlet weak var thumbnailImageView3: UIImageView!
    @IBOutlet weak var thumbnailImageView4: UIImageView!
    @IBOutlet weak var thumbnailImageView5: UIImageView!
    
    private let kTransitionDuration = 0.4
    private var isPresenting: Bool = true
    
    private var thumbnailImageViews : [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
        // Track these in an array
        thumbnailImageViews.append(thumbnailImageView1)
        thumbnailImageViews.append(thumbnailImageView2)
        thumbnailImageViews.append(thumbnailImageView3)
        thumbnailImageViews.append(thumbnailImageView4)
        thumbnailImageViews.append(thumbnailImageView5)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.startAnimating()
        delay(2, { () -> () in
            self.activityIndicator.stopAnimating()
            self.scrollView.alpha = 1
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
        
        // Copy the background view from PhotoViewController
        var backgroundView = UIView(frame: photoViewController.backgroundView.frame)
        backgroundView.backgroundColor = photoViewController.backgroundView.backgroundColor
        
        // Copy the thumbnail image
        var imageView = UIImageView(image: thumbnailImageView.image)
        
        // Add them both to our view
        view.addSubview(backgroundView)
        view.addSubview(imageView)
        
        // Calculate the frame of the thumbnail if the image wasn't clipped
        var thumbnailFrame = getResizedFrameFromAspectFill(thumbnailImageView.image!, thumbnailImageView.frame)
        thumbnailFrame.origin = view.convertPoint(thumbnailFrame.origin, fromView: thumbnailImageView.superview)
        
        if (isPresenting) {
            // Set background to transparent & set image frame to thumbnail
            backgroundView.alpha = 0
            imageView.frame = thumbnailFrame
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                // Set background to opaque & set
                backgroundView.alpha = 1
                imageView.frame = photoViewController.getImageFrame()
                }) { (finished: Bool) -> Void in
                    // Bring the PhotoViewController to view
                    containerView.addSubview(photoViewController.view)
                    
                    // Remove the views
                    backgroundView.removeFromSuperview()
                    imageView.removeFromSuperview()
                    
                    // Mark the transition as complete
                    transitionContext.completeTransition(true)
            }
        } else {
            // Remove the PhotoViewController view
            photoViewController.view.removeFromSuperview()

            // Set image frame photo
            imageView.frame = photoViewController.getImageFrame()
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                // Set background to transparent & set image frame to thumbnail
                backgroundView.alpha = 0
                imageView.frame = thumbnailFrame
                }) { (finished: Bool) -> Void in
                    // Remove the views
                    backgroundView.removeFromSuperview()
                    imageView.removeFromSuperview()
                    
                    // Mark the transition as complete
                    transitionContext.completeTransition(true)
            }
        }
    }

    @IBAction func onThumbnailTap(sender: UITapGestureRecognizer) {
        var thumbnailImageView = sender.view as UIImageView
        var imageIndex = find(thumbnailImageViews, thumbnailImageView)
        var photoViewController = storyboard?.instantiateViewControllerWithIdentifier(kPhotoViewControllerID) as PhotoViewController
        photoViewController.imageIndex = imageIndex == nil ? 0 : imageIndex!
        photoViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        photoViewController.transitioningDelegate = self
        presentViewController(photoViewController, animated: true, completion: nil)
    }
}