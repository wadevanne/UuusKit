//
//  UuusStringsAndText_.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func numberOfLines(bounded: CGFloat?) -> Int {
        let emptyString = NSAttributedString(string: String.empty)
        let eachHeight = emptyString.upright(boundedAclinic: bounded)
        let wholeHeight = upright(boundedAclinic: bounded)
        return Int((wholeHeight/eachHeight).rounded(.up))
    }
    ///  ________________
    /// ┃                ┃
    /// ┃________________┃ boundedUpright
    ///  aclinic
    func aclinic(boundedUpright: CGFloat?) -> CGFloat {
        return float(boundedUpright ?? CGFloat(UInt8.min), isBoundedVertical: true)
    }
    ///  ________________
    /// :                : upright
    /// :________________:
    ///          boundedAclinic
    func upright(boundedAclinic: CGFloat?) -> CGFloat {
        return float(boundedAclinic ?? CGFloat(UInt8.min), isBoundedVertical: false)
    }
    
    private func float(_ float: CGFloat, isBoundedVertical: Bool) -> CGFloat {
        let height = isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let width = !isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = boundingRect(with: size, options: options, context: nil)
        return isBoundedVertical ? rect.width : rect.height
    }
}
