//
//  UuusCoreAnimation.swift
//  Example
//
//  Created by 范炜佳 on 25/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import QuartzCore

open class PieLayor: CAShapeLayer {

    // MARK: - Initialization

    public init(arcCenter center: CGPoint, radius: CGFloat, startAngle zero: CGFloat = 0, endAngle nine: CGFloat = CGFloat(uuus2mpi), clockwise: Bool = true, lineWidth width: CGFloat = 3, strokeColor color: CGColor = .lightGray) {
        super.init()
        /// rotate 90 degrees to 12‘c
        path = UIBezierPath(arcCenter: center, radius: radius, startAngle: zero - CGFloat(uuusm2pi), endAngle: nine - CGFloat(uuusm2pi), clockwise: clockwise).cgPath
        fillColor = .clear
        strokeColor = color
        strokeStart = 0
        strokeEnd = 1
        lineWidth = width
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
