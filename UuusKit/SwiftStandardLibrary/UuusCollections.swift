//
//  UuusCollections.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Foundation

extension Array {
    public var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}

extension Array where Element == Date.DateFormat {
    public var dateFormat: String {
        let array = sorted {
            $0.hashValue > $1.hashValue
        }
        let maybe = "\(String.white)\(array.last!.rawValue)"
        let suffix = array.count > 1 ? maybe : String.empty
        return "\(array.first!.rawValue)\(suffix)"
    }
}

extension Dictionary {
    public var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }

    public var urlEncode: Dictionary {
        var selves = self
        for key in keys {
            if var value = self[key] as? String {
                let white = CharacterSet.whitespaces
                value = value.trimmingCharacters(in: white)
                selves[key] = value.urlEncode as? Value
            }
            continue
        }
        return selves
    }
}

extension Dictionary {
    @discardableResult
    public mutating func removeValues(forKeys keys: [Dictionary.Key]) -> [Dictionary.Value]? {
        var removeValues: [Dictionary.Value] = []
        keys.forEach { key in
            if let value = removeValue(forKey: key) {
                removeValues.append(value)
            }
        }
        return removeValues
    }
}
