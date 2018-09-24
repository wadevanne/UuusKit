//
//  UuusStringsAndText_.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension NSAttributedString {
    // MARK: - Public - Functions

    public func numberOfLines(bounded: CGFloat = CGFloat(UInt8.min)) -> Int {
        let emptyString = NSAttributedString(string: .empty)
        let eachHeight = emptyString.upright(boundedAclinic: bounded)
        let wholeHeight = upright(boundedAclinic: bounded)
        return Int((wholeHeight / eachHeight).rounded(.up))
    }

    ///  ________________
    /// ┃                ┃
    /// ┃________________┃ boundedUpright
    ///         aclinic
    public func aclinic(boundedUpright: CGFloat = CGFloat(UInt8.min)) -> CGFloat {
        return float(boundedUpright, isBoundedVertical: true)
    }

    ///  ________________
    /// :                : upright
    /// :________________:
    ///                 boundedAclinic
    public func upright(boundedAclinic: CGFloat = CGFloat(UInt8.min)) -> CGFloat {
        return float(boundedAclinic, isBoundedVertical: false)
    }

    // MARK: - Private - Functions

    private func float(_ float: CGFloat, isBoundedVertical: Bool) -> CGFloat {
        let height = isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let width = !isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = boundingRect(with: size, options: options, context: nil)
        return isBoundedVertical ? rect.width : rect.height
    }
}
