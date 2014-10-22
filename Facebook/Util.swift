//
//  Util.swift
//  Facebook
//
//  Created by Mel Ludowise on 10/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

// Resizes the imageView such that it fit inside the given size.
// Equivalent to Aspect Fit but leaves the ImageView aspect ratio the same as the image
func resizeAndRepositionImageToAspectFit(imageView: UIImageView, bounds: CGRect) {
    var scaledImageBounds = bounds
    var imageSize = imageView.image!.size
    
    if (imageSize.height / imageSize.width > bounds.size.height / bounds.size.width) {
        // Image is taller than wanted size
        scaledImageBounds.size.width = imageSize.width / imageSize.height * bounds.size.height
    } else {
        // Image is wider than wanted size
        scaledImageBounds.size.height = imageSize.height / imageSize.width * bounds.size.width
    }
    
    scaledImageBounds.origin.x += (imageView.frame.width - scaledImageBounds.width)/2
    scaledImageBounds.origin.y += (imageView.frame.height - scaledImageBounds.height)/2
    imageView.frame = scaledImageBounds
}

// Resizes the imageView such that it fills the given size.
// Equivalent to Aspect Fill but leaves the ImageView aspect ratio the same as the image
func resizeAndRepositionImageToAspectFill(imageView: UIImageView, size: CGSize) {
    var scaledImageSize = size
    var imageSize = imageView.image!.size
    
    if (imageSize.height / imageSize.width > size.height / size.width) {
        // Image is taller than wanted size
        scaledImageSize.height = imageSize.height / imageSize.width * size.width
    } else {
        // Image is wider than wanted size
        scaledImageSize.width = imageSize.width / imageSize.height * size.height
    }
}