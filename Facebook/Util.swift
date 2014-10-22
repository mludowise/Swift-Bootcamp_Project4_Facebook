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

func getResizedFrameFromAspectFill(image: UIImage, frame: CGRect) -> CGRect {
    var newFrame = frame
    if (image.size.height / image.size.width > frame.height / frame.width) {
        // Image is taller than view
        newFrame.size.height = image.size.height / image.size.width * frame.width
        newFrame.origin.y += frame.height - newFrame.height
    } else {
        // Image is wider than view
        newFrame.size.width = image.size.width / image.size.height * frame.height
        newFrame.origin.x += frame.width - newFrame.width
    }
    return newFrame
}