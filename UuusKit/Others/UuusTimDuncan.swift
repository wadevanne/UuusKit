//
//  UuusTimDuncan.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

// MARK: - Enumerations
// MARK: - Classes and Structures

// MARK: - IBOutlets
// MARK: - IBActions
// MARK: - Singleton

public let uuus2MPI = 2.0 * .pi
public let uuusM2PI = 0.5 * .pi

public var app1ication = UIApplication.shared
public var appDe1egate = app1ication.delegate /*! as! AppDelegate */
public var ca1endar = Calendar.current
public var n0tification = NotificationCenter.default

// MARK: - Initialization
// MARK: - Deinitialization
// MARK: - Lazy Initialization
// MARK: - Closures

public typealias completionc = ((_ data: Any?) -> Swift.Void)
public typealias exceptionc = ((_ code: Int?, _ info: String?) -> Swift.Void)
public typealias failurec = ((_ error: Error?) -> Swift.Void)

// MARK: - Properties

public var control1er: UIViewController? {
    return UIViewController.playground()
}

public var screenBounds = UIScreen.main.bounds
public var screenHeight = screenBounds.height
public var screenWidth = screenBounds.width
public var screenWidth8 = screenWidth / 8

public var statusHeight = app1ication.statusBarFrame.height

// MARK: - Serialization
// MARK: - View Handling
// MARK: - Public - Functions

public func ceil<T>(_ comparable: T) -> T where T: Comparable {
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

public func floor<T>(_ comparable: T) -> T where T: Comparable {
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

public func asyncAfter(_ seconds: TimeInterval, completion: @escaping completionc) {
    let integer = Int64(seconds * TimeInterval(NSEC_PER_SEC))
    let popTime = DispatchTime.now() + TimeInterval(integer) / TimeInterval(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion(popTime)
    }
}

public func telephone(_ telephone: String) {
    let uiWebView = UIWebView()
    let url = URL(string: "tel:\(telephone)")
    uiWebView.loadRequest(URLRequest(url: url!))
    control1er?.view.addSubview(uiWebView)
}

// MARK: - Private - Functions
// MARK: - Delegates
// MARK: - KVO
// MARK: - Error Handling
