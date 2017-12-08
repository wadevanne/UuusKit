//
//  UuusTouchesPressesAndGestures.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIResponder {

    // MARK: - Properties

    public static var nib: UINib? {
        let bundle = Bundle(for: self)
        if bundle.path(forResource: name, ofType: "nib") == nil {
            return nil
        }
        return UINib(nibName: name, bundle: bundle)
    }

    public static var xib: UIResponder? {
        return nib?.instantiate(withOwner: self, options: nil).first as? UIResponder
    }
}
