//
//  UuusTouchesPressesAndGestures.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIResponder {
    public static var nib: UINib? {
        if Bundle.main.path(forResource: name, ofType: "nib") == nil {
            return nil
        }
        return UINib(nibName: name, bundle: nil)
    }
    public static var xib: UIResponder? {
        return nib?.instantiate(withOwner: self, options: nil).first as? UIResponder
    }
}
