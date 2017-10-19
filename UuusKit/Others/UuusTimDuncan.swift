//
//  UuusTimDuncan.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

typealias completionc = ((_ data: Any?) -> Swift.Void)
typealias exceptionc = ((_ code: Int?, _ info: String?) -> Swift.Void)
typealias failurec = ((_ error: Error?) -> Swift.Void)

let uuus2MPI = 2.0 * .pi
let uuusM2PI = 0.5 * .pi

var app1ication = UIApplication.shared
var appDe1egate = app1ication.delegate /*! as! AppDelegate */
var ca1endar = Calendar.current
var n0tification = NotificationCenter.default

var contro1ler: UIViewController? {
    return UIViewController.playground()
}

var screenBounds = UIScreen.main.bounds
var screenHeight = screenBounds.height
var screenWidth = screenBounds.width
var screenWidth8 = screenWidth / 8

var statusHeight = app1ication.statusBarFrame.height

func ceil<T>(_ comparable: T) -> T where T: Comparable {
    if comparable is CGFloat {
        let double = Double(comparable as! CGFloat)
        return CGFloat(ceil(double)) as! T
    }
    if comparable is Double {
        return ceil(comparable as! Double) as! T
    }
    if comparable is Float {
        return ceilf(comparable as! Float) as! T
    }
    return comparable
}

func floor<T>(_ comparable: T) -> T where T: Comparable {
    if comparable is CGFloat {
        let double = Double(comparable as! CGFloat)
        return CGFloat(floor(double)) as! T
    }
    if comparable is Double {
        return floor(comparable as! Double) as! T
    }
    if comparable is Float {
        return floorf(comparable as! Float) as! T
    }
    return comparable
}

func asyncAfter(_ seconds: TimeInterval, completion: @escaping completionc) {
    let integer = Int64(seconds * TimeInterval(NSEC_PER_SEC))
    let popTime = DispatchTime.now() + TimeInterval(integer) / TimeInterval(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion(popTime)
    }
}
