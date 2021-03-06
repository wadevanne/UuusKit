//
//  UuusStringsAndText.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension String {
    // MARK: - Singleton

    public static let empty = ""
    public static let white = " "
    public static let short = "-"
    public static let marka = "%@"
    public static let leave = "--"

    public static let ftp = "ftp://"
    public static let http = "http://"
    public static let https = "https://"
}

extension String {
    // MARK: - Properties

    public var data: Data? {
        return data(using: .utf8)
    }

    public var local: String {
        return localise(self)
    }

    public var digit: String {
        return split { !"0123456789".contains($0) }.joined(separator: .empty)
    }

    public var latin: String {
        let latin = NSMutableString(string: self)
        CFStringTransform(latin, nil, kCFStringTransformToLatin, false)
        CFStringTransform(latin, nil, kCFStringTransformStripDiacritics, false)
        return latin.uppercased
    }

    /// let a = "a bc  d    efg"
    ///
    /// print(a.unity)
    /// abcdefg
    public var unity: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "")
    }

    /// let a = "AEAEAE"
    ///
    /// print(a.color)
    /// UIExtendedSRGBColorSpace 0.682353 0.682353 0.682353 1
    public var color: UIColor {
        return UIColor(hexColor: self)
    }

    public var nsstr: NSString {
        return NSString(string: self)
    }

    public var isURL: Bool {
        let regex = "^(?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?$"
        return match(regex: regex, value: self)
    }

    public var isChinaPhone: Bool {
        let regex = "((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}"
        return match(regex: regex, value: self)
    }

    public var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return match(regex: regex, value: self)
    }

    /// /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$/
    /// /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
    public var isValidIdNum: Bool {
        let regex = "([1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3})|([1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X))"
        return match(regex: regex, value: self)
    }

    public var isAllNumbers: Bool {
        return match(regex: "[0-9]{1,}", value: self)
    }

    public var isHasNumbers: Bool {
        return match(regex: ".*?\\d+.*?", value: self)
    }

    public var isHasULetter: Bool {
        return match(regex: ".*?[A-Z]+.*?", value: self)
    }

    public var isHasLLetter: Bool {
        return match(regex: ".*?[a-z]+.*?", value: self)
    }

    public var isHasSpecial: Bool {
        return match(regex: ".*?[^A-Za-z0-9]+.*?", value: self)
    }

    public var isHasChinese: Bool {
        return match(regex: ".*?[\\u4e00-\\u9fa5]+.*?", value: self)
    }

    /// let a = ".*?[\\u4e00-\\u9fa5]+.*?"
    ///
    /// print(a.urlEncode)
    /// Optional(".%2A%3F%5B\\u4e00-\\u9fa5%5D%2B.%2A%3F")
    public var urlEncode: String? {
        let str = "!*'();:@&=+$,/?%#[]"
        let set = CharacterSet(charactersIn: str).inverted
        return addingPercentEncoding(withAllowedCharacters: set)
    }

    public var enbase64Data: Data? {
        return data?.base64EncodedData(options: .lineLength64Characters)
    }

    public var enbase64String: String? {
        return data?.base64EncodedString(options: .lineLength64Characters)
    }

    public var debase64Data: Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }

    public subscript(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let ended = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< ended])
    }
}

extension String {
    // MARK: - Public - Functions

    public func formattedPhone(any: Character = Character(String.white)) -> String {
        var formattedPhone = self
        formattedPhone.insert(any, at: index(endIndex, offsetBy: -4))
        formattedPhone.insert(any, at: index(startIndex, offsetBy: 3))
        return formattedPhone
    }

    public func formattedIdNum(any: Character = Character(String.white)) -> String {
        var formattedIdNum = self
        let i = formattedIdNum.count < 17 ? 3 : 4
        formattedIdNum.insert(any, at: index(endIndex, offsetBy: -i))
        formattedIdNum.insert(any, at: index(startIndex, offsetBy: 6))
        return formattedIdNum
    }

    public func shieldedPhone(any: String = "****") -> String {
        guard isChinaPhone else {
            return self
        }
        let white = String.white
        let phone = formattedPhone()
        let array = phone.components(separatedBy: white)
        return "\(array.first!)\(any)\(array.last!)"
    }

    public func shieldedIdNum(any: String = "******") -> String {
        guard isValidIdNum else {
            return self
        }
        let white = String.white
        let idnum = formattedIdNum()
        let array = idnum.components(separatedBy: white)
        return "\(array.first!)\(any)\(array.last!)"
    }

    public func localise(_ comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }

    public func match(regex: String, value: String) -> Bool {
        let predicate = NSPredicate(format: "self matches %@", regex)
        return predicate.evaluate(with: value)
    }

    public func numberOfLines(bounded: CGFloat = CGFloat(UInt8.min), font: UIFont) -> Int {
        let eachHeight = String.empty.upright(boundedAclinic: bounded, font: font)
        let wholeHeight = upright(boundedAclinic: bounded, font: font)
        return Int((wholeHeight / eachHeight).rounded(.up))
    }

    ///  ________________
    /// ┃                ┃
    /// ┃________________┃ boundedUpright
    ///         aclinic
    public func aclinic(boundedUpright: CGFloat = CGFloat(UInt8.min), font: UIFont) -> CGFloat {
        return float(boundedUpright, font: font, isBoundedVertical: true)
    }

    ///  ________________
    /// :                : upright
    /// :________________:
    ///                 boundedAclinic
    public func upright(boundedAclinic: CGFloat = CGFloat(UInt8.min), font: UIFont) -> CGFloat {
        return float(boundedAclinic, font: font, isBoundedVertical: false)
    }

    // MARK: - Private - Functions

    private func float(_ float: CGFloat, font: UIFont, isBoundedVertical: Bool) -> CGFloat {
        let height = isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let width = !isBoundedVertical ? float : CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedString.Key.font: font]
        let rect = nsstr.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return isBoundedVertical ? rect.width : rect.height
    }
}
