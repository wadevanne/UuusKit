//
//  UuusNumbersDataAndBasicValues_.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Foundation

extension Data {
    public var array: [Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) as? [Any]
    }

    public var string: String? {
        return String(data: self, encoding: .utf8)
    }

    public var dictionary: [AnyHashable: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) as? [AnyHashable: Any]
    }

    public var enbase64Data: Data {
        return base64EncodedData(options: .lineLength64Characters)
    }

    public var debase64Data: Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }

    public var enbase64String: String {
        return base64EncodedString(options: .lineLength64Characters)
    }

    public var debase64String: String? {
        return debase64Data?.string
    }
}
