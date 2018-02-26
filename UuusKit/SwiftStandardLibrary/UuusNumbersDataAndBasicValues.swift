//
//  UuusNumbersDataAndBasicValues.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Foundation

extension Double {

    // MARK: - Properties

    public var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "¥ "
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
}
