//
//  UuusNumbersDataAndBasicValues_.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Foundation

extension Data {
    var dictionary: [AnyHashable : Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) as? [AnyHashable : Any]
    }
}
