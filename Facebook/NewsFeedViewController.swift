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
    
    private let kTransitionDuration = 0.4
    private var isPresenting: Bool = true
    private var transitionImageView = UIImageView()
    private var scaledThumbnailFrame : CGRect!
    private var imageBackgroundView = UIView(frame: UIScreen.mainScreen().bounds)
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    
    private var thumbnailImageViews : [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailImageViews.append(imageView1)
        thumbnailImageViews.append(imageView2)
        thumbnailImageViews.append(imageView3)
        thumbnailImageViews.append(imageView4)
        thumbnailImageViews.append(imageView5)

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
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

        var feedViewController = isPresenting ?
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! :
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        var photoViewController = isPresenting ?
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as PhotoViewController :
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as PhotoViewController
        
        var imageIndex = photoViewController.getImageIndex()
        var thumbnailImageView = thumbnailImageViews[imageIndex]
        var thumbnailFrame = thumbnailImageView.frame
        var scaledThumbnailSize : CGSize!
        var thumbnailSize = thumbnailImageView.image!.size
        if (thumbnailSize.height / thumbnailSize.width > thumbnailFrame.size.height / thumbnailFrame.size.width) {
            // Image is taller than thumbnail
            scaledThumbnailSize = CGSize(width: thumbnailFrame.width, height: thumbnailSize.height / thumbnailSize.width * thumbnailFrame.size.width)
        } else {
            // Image is wider than thumbnail
            scaledThumbnailSize = CGSize(width: thumbnailSize.width / thumbnailSize.height * thumbnailFrame.size.height, height: thumbnailFrame.height)
        }
        var convertedThumbnailOrigin = view.convertPoint(thumbnailFrame.origin, fromView: thumbnailImageView.superview?)
        scaledThumbnailFrame = CGRect(origin:
            CGPoint(x: convertedThumbnailOrigin.x + (thumbnailFrame.width - scaledThumbnailSize.width) / 2,
                y: convertedThumbnailOrigin.y + (thumbnailFrame.height - scaledThumbnailSize.height) / 2), size: scaledThumbnailSize)
        
        transitionImageView.image = photoViewController.getImage()
        
        if (isPresenting) {
            imageBackgroundView.alpha = 0
            transitionImageView.frame = scaledThumbnailFrame
            feedViewController.view.addSubview(imageBackgroundView)
            feedViewController.view.addSubview(transitionImageView)
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                self.imageBackgroundView.alpha = 1
                self.transitionImageView.frame = UIScreen.mainScreen().bounds
                }) { (finished: Bool) -> Void in
                    self.imageBackgroundView.hidden = true
                    self.transitionImageView.hidden = true
                    containerView.addSubview(photoViewController.view)
                    transitionContext.completeTransition(true)
            }
        } else {
            photoViewController.view.removeFromSuperview()
            
            imageBackgroundView.hidden = false
            transitionImageView.hidden = false
            
            // Take into consideration the position insize the scrollView of the photo in the PhotoViewController
            var offsetAndZoom = photoViewController.getImageOffsetAndZoom()
            transitionImageView.frame.size.width *= offsetAndZoom.zoomScale
            transitionImageView.frame.size.height *= offsetAndZoom.zoomScale
            transitionImageView.frame.origin.x -= offsetAndZoom.offset.x
            transitionImageView.frame.origin.y -= offsetAndZoom.offset.y
            
            println(offsetAndZoom.offset)
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                self.imageBackgroundView.alpha = 0
                self.transitionImageView.frame = self.scaledThumbnailFrame
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    self.imageBackgroundView.removeFromSuperview()
                    self.transitionImageView.removeFromSuperview()
            }
        }
    }
    
     @IBAction func onThumbnailTap(sender: UITapGestureRecognizer) {
        var thumbnailImageView = sender.view as UIImageView
        var photoViewController = storyboard?.instantiateViewControllerWithIdentifier(kPhotoViewControllerID) as PhotoViewController
//        photoViewController.image = thumbnailImageView.image
        photoViewController.loadWithImageIndex = find(thumbnailImageViews, thumbnailImageView)!
        photoViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        photoViewController.transitioningDelegate = self
        presentViewController(photoViewController, animated: true, completion: nil)
    }
}