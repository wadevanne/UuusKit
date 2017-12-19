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

        case visual
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
        case iPhoneX = "5.8-inch"

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
        /// "iPad6,11" on iPad (5th generation) - Wifi (model A1822)
        /// "iPad6,12" on iPad (5th generation) - Wifi + Cellular (model A1823)
        case iPadAir = "9.7-inch"
        /// "iPad7,3" on iPad Pro 10.5" - Wifi (model A1701)
        /// "iPad7,4" on iPad Pro 10.5" - Wifi + Cellular (model A1709)
        case iPadPrc = "10.5-inch"
        /// "iPad6,3" on iPad Pro 12.9" - Wifi (model A1673)
        /// "iPad6,4" on iPad Pro 12.9" - Wifi + Cellular (model A1674)
        /// "iPad6,4" on iPad Pro 12.9" - Wifi + Cellular (model A1675)
        /// "iPad7,1" on iPad Pro 12.9" (2nd generation) - Wifi (model A1670)
        /// "iPad7,2" on iPad Pro 12.9" (2nd generation) - Wifi + Cellular (model A1671)
        /// "iPad7,2" on iPad Pro 12.9" (2nd generation) - Wifi + Cellular (model A1821)
        case iPadPro = "12.9-inch"

        public static func < (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue < rhs.hashValue
        }

        public static func <= (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue <= rhs.hashValue
        }

        public static func > (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue > rhs.hashValue
        }

        public static func >= (lhs: DeviceType, rhs: DeviceType) -> Bool {
            return lhs.hashValue >= rhs.hashValue
        }
    }
}

extension UIDevice {

    // MARK: - Properties

    public static var type: DeviceType {
        switch current.modelName {
        case "iPhone1,1", "iPhone1,2",
             "iPhone2,1":
            return DeviceType.iPhone
        case "iPad1,1",
             "iPad2,1", "iPad2,2", "iPad2,3",
             "iPad2,4", "iPad2,5", "iPad2,6",
             "iPad2,7":
            return DeviceType.iPad

        case "i386":
            if isPhone {
                return DeviceType.iPhone
            }
            if isPad {
                return DeviceType.iPad
            }
            return DeviceType.visual
        case "x86_64":
            switch (screenHeight, screenWidth) {
            case (320.0, 480.0), (480.0, 320.0):
                return DeviceType.iPhone4s
            case (320.0, 568.0), (568.0, 320.0):
                return DeviceType.iPhoneSE
            case (375.0, 667.0), (667.0, 375.0):
                return DeviceType.iPhone6
            case (414.0, 736.0), (736.0, 414.0):
                return DeviceType.iPhone9P
            case (375.0, 812.0), (812.0, 375.0):
                return DeviceType.iPhoneX
            default:
                return DeviceType.retina
            }

        case "iPhone3,1", "iPhone3,3",
             "iPhone4,1":
            return DeviceType.iPhone4s
        case "iPhone5,1", "iPhone5,2",
             "iPhone5,3", "iPhone5,4",
             "iPhone6,1", "iPhone6,2",
             "iPhone8,4":
            return DeviceType.iPhoneSE
        case "iPhone7,2",
             "iPhone8,1",
             "iPhone9,1", "iPhone9,3",
             "iPhone10,1", "iPhone10,4":
            return DeviceType.iPhone6
        case "iPhone7,1",
             "iPhone8,2",
             "iPhone9,2", "iPhone9,4",
             "iPhone10,2", "iPhone10,5":
            return DeviceType.iPhone9P
        case "iPhone10,3", "iPhone10,6":
            return DeviceType.iPhoneX

        case "iPad4,4", "iPad4,5", "iPad4,6",
             "iPad4,7", "iPad4,8", "iPad4,9",
             "iPad5,1", "iPad5,2":
            return DeviceType.iPadmini
        case "iPad3,1", "iPad3,2", "iPad3,3",
             "iPad3,4", "iPad3,5", "iPad3,6",
             "iPad4,1", "iPad4,2", "iPad4,3",
             "iPad5,3", "iPad5,4",
             "iPad6,7", "iPad6,8",
             "iPad6,11", "iPad6,12":
            return DeviceType.iPadAir
        case "iPad7,3", "iPad7,4":
            return DeviceType.iPadPrc
        case "iPad6,3", "iPad6,4",
             "iPad7,1", "iPad7,2":
            return DeviceType.iPadPro

        default:
            return DeviceType.retina
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

    public static var identifier = "DeviceIdentifier"
}

extension UIDevice {

    // MARK: - Properties

    public var modelName: String {
        var systemInformation = utsname()
        uname(&systemInformation)
        let machine = systemInformation.machine
        let mirror = Mirror(reflecting: machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            let int8 = element.value as? Int8
            guard let value = int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
