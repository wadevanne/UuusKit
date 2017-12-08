//
//  UuusDrawing.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Initialization

    public convenience init(hexColor: String) {
        var R: UInt32 = 0, G: UInt32 = 0, B: UInt32 = 0
        Scanner(string: hexColor[0 ..< 2]).scanHexInt32(&R)
        Scanner(string: hexColor[2 ..< 4]).scanHexInt32(&G)
        Scanner(string: hexColor[4 ..< 6]).scanHexInt32(&B)
        self.init(R: CGFloat(R), G: CGFloat(G), B: CGFloat(B))
    }

    public convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1) {
        self.init(red: R / 255, green: G / 255, blue: B / 255, alpha: A)
    }
}

extension UIColor {

    // MARK: - Properties

    public var image: UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: .zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
