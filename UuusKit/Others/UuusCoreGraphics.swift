//
//  UuusCoreGraphics.swift
//  Example
//
//  Created by 范炜佳 on 1/11/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension CGColor {

    // MARK: - Properties

    /// 0.0 white
    public static var black: CGColor {
        return UIColor.black.cgColor
    }

    /// 0.333 white
    public static var darkGray: CGColor {
        return UIColor.darkGray.cgColor
    }

    /// 0.667 white
    public static var lightGray: CGColor {
        return UIColor.lightGray.cgColor
    }

    /// 1.0 white
    public static var white: CGColor {
        return UIColor.white.cgColor
    }

    /// 0.5 white
    public static var gray: CGColor {
        return UIColor.gray.cgColor
    }

    /// 1.0, 0.0, 0.0 RGB
    public static var red: CGColor {
        return UIColor.red.cgColor
    }

    /// 0.0, 1.0, 0.0 RGB
    public static var green: CGColor {
        return UIColor.green.cgColor
    }

    /// 0.0, 0.0, 1.0 RGB
    public static var blue: CGColor {
        return UIColor.blue.cgColor
    }

    /// 0.0, 1.0, 1.0 RGB
    public static var cyan: CGColor {
        return UIColor.cyan.cgColor
    }

    /// 1.0, 1.0, 0.0 RGB
    public static var yellow: CGColor {
        return UIColor.yellow.cgColor
    }

    /// 1.0, 0.0, 1.0 RGB
    public static var magenta: CGColor {
        return UIColor.magenta.cgColor
    }

    /// 1.0, 0.5, 0.0 RGB
    public static var orange: CGColor {
        return UIColor.orange.cgColor
    }

    /// 0.5, 0.0, 0.5 RGB
    public static var purple: CGColor {
        return UIColor.purple.cgColor
    }

    /// 0.6, 0.4, 0.2 RGB
    public static var brown: CGColor {
        return UIColor.brown.cgColor
    }

    /// 0.0 white, 0.0 alpha
    public static var clear: CGColor {
        return UIColor.clear.cgColor
    }
}

extension CGColor {

    // MARK: - Properties

    public var uiColor: UIColor {
        return UIColor(cgColor: self)
    }
}
