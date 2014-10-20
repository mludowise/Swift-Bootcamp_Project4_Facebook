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
