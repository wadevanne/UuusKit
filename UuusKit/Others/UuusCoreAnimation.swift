//
//  UuusCoreAnimation.swift
//  Example
//
//  Created by 范炜佳 on 25/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import QuartzCore

extension CATransition {

    // MARK: - Properties

    public static var fade: CATransition {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        transition.duration = 0.25
        return transition
    }
}
