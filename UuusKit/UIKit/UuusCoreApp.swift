//
//  UuusCoreApp.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIDevice {
    var modelName: String {
        var systemInformation = utsname()
        uname(&systemInformation)
        let machine = systemInformation.machine
        let mirror = Mirror(reflecting: machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
