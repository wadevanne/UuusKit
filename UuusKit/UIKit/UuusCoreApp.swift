//
//  UuusCoreApp.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIDevice {

    // MARK: - Enumerations

    public enum DeviceType: String {
        /// "iPhone1,1" on iPhone
        /// "iPhone1,2" on iPhone 3G
        /// "iPhone2,1" on iPhone 3GS
        case iPhone
        /// "iPad1,1" on iPad - Wifi (model A1219)
        /// "iPad1,1" on iPad - Wifi + Cellular (model A1337)
        /// "iPad2,1" on iPad 2 - Wifi (model A1395)
        /// "iPad2,2" on iPad 2 - GSM (model A1396)
        /// "iPad2,3" on iPad 2 - 3G (model A1397)
        /// "iPad2,4" on iPad 2 - Wifi (model A1395)
        /// "iPad2,5" on iPad Mini - Wifi (model A1432)
        /// "iPad2,6" on iPad Mini - Wifi + Cellular (model  A1454)
        /// "iPad2,7" on iPad Mini - Wifi + Cellular (model  A1455)
        case iPad

        case retina

        case appleWatch38 = "38mm"
        case appleWatch42 = "42mm"

        /// "iPhone3,1" on iPhone 4 (GSM)
        /// "iPhone3,3" on iPhone 4 (CDMA/Verizon/Sprint)
        /// "iPhone4,1" on iPhone 4s
        case iPhone4s = "3.5-inch"
        /// "iPhone5,1" on iPhone 5 (model A1428, AT&T/Canada)
        /// "iPhone5,2" on iPhone 5 (model A1429, everything else)
        /// "iPhone5,3" on iPhone 5c (model A1456, A1532 | GSM)
        /// "iPhone5,4" on iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
        /// "iPhone6,1" on iPhone 5s (model A1433, A1533 | GSM)
        /// "iPhone6,2" on iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
        /// "iPhone8,4" on iPhone SE
        case iPhoneSE = "4.0-inch"
        /// "iPhone7,2" on iPhone 6
        /// "iPhone8,1" on iPhone 6s
        /// "iPhone9,1" on iPhone 7 (CDMA)
        /// "iPhone9,3" on iPhone 7 (GSM)
        /// "iPhone10,1" on iPhone 8 (CDMA)
        /// "iPhone10,4" on iPhone 8 (GSM)
        case iPhone6 = "4.7-inch"
        /// "iPhone7,1" on iPhone 6 Plus
        /// "iPhone8,2" on iPhone 6s Plus
        /// "iPhone9,2" on iPhone 7 Plus (CDMA)
        /// "iPhone9,4" on iPhone 7 Plus (GSM)
        /// "iPhone10,2" on iPhone 8 Plus (CDMA)
        /// "iPhone10,5" on iPhone 8 Plus (GSM)
        case iPhone9P = "5.5-inch"
        /// "iPhone10,3" on iPhone X (CDMA)
        /// "iPhone10,6" on iPhone X (GSM)
        case iPhoneX = "5.9-inch"

        /// "iPad4,4" on iPad Mini 2 - Wifi (model A1489)
        /// "iPad4,5" on iPad Mini 2 - Wifi + Cellular (model A1490)
        /// "iPad4,6" on iPad Mini 2 - Wifi + Cellular (model A1491)
        /// "iPad4,7" on iPad Mini 3 - Wifi (model A1599)
        /// "iPad4,8" on iPad Mini 3 - Wifi + Cellular (model A1600)
        /// "iPad4,9" on iPad Mini 3 - Wifi + Cellular (model A1601)
        /// "iPad5,1" on iPad Mini 4 - Wifi (model A1538)
        /// "iPad5,2" on iPad Mini 4 - Wifi + Cellular (model A1550)
        case iPadmini = "7.9-inch"
        /// "iPad3,1" on iPad 3 - Wifi (model A1416)
        /// "iPad3,2" on iPad 3 - Wifi + Cellular (model  A1403)
        /// "iPad3,3" on iPad 3 - Wifi + Cellular (model  A1430)
        /// "iPad3,4" on iPad 4 - Wifi (model A1458)
        /// "iPad3,5" on iPad 4 - Wifi + Cellular (model  A1459)
        /// "iPad3,6" on iPad 4 - Wifi + Cellular (model  A1460)
        /// "iPad4,1" on iPad Air - Wifi (model A1474)
        /// "iPad4,2" on iPad Air - Wifi + Cellular (model A1475)
        /// "iPad4,3" on iPad Air - Wifi + Cellular (model A1476)
        /// "iPad5,3" on iPad Air 2 - Wifi (model A1566)
        /// "iPad5,4" on iPad Air 2 - Wifi + Cellular (model A1567)
        /// "iPad6,7" on iPad Pro 9.7" - Wifi (model A1584)
        /// "iPad6,8" on iPad Pro 9.7" - Wifi + Cellular (model A1652)
        case iPadAir = "9.7-inch"
        case iPadPrx = "10.5-inch"
        /// "iPad6,3" on iPad Pro 12.9" - Wifi (model A1673)
        /// "iPad6,4" on iPad Pro 12.9" - Wifi + Cellular (model A1674)
        /// "iPad6,4" on iPad Pro 12.9" - Wifi + Cellular (model A1675)
        case iPadPro = "12.9-inch"

        static func < (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue < rhs.hashValue
        }

        static func <= (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue <= rhs.hashValue
        }

        static func > (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue > rhs.hashValue
        }

        static func >= (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue >= rhs.hashValue
        }
    }
}

extension UIDevice {

    // MARK: - Properties

    public static var type: DeviceType {
        switch (screenHeight, screenWidth) {
        case (320.0, 480.0), (480.0, 320.0):
            return .iPhone4s
        case (320.0, 568.0), (568.0, 320.0):
            return .iPhoneSE
        case (375.0, 667.0), (667.0, 375.0):
            return .iPhone6
        case (414.0, 736.0), (736.0, 414.0):
            return .iPhone9P
        case (375.0, 812.0), (812.0, 375.0):
            return .iPhoneX
        default:
            return .retina
        }
    }

    public static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }

    public static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }

    public static var isSimulator: Bool {
        return NSNumber(value: TARGET_OS_SIMULATOR).boolValue
    }

    public static var Identifier = "DeviceIdentifier"
}

extension UIDevice {

    // MARK: - Properties

    public var modelName: String {
        var systemInformation = utsname()
        uname(&systemInformation)
        let machine = systemInformation.machine
        let mirror = Mirror(reflecting: machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
