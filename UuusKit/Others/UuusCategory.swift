//
//  UuusCategory.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import PKHUD

extension HUD {
    static func show(_ contentView: UIView, onView view: UIView? = nil) {
        PKHUD.sharedHUD.contentView = contentView
        PKHUD.sharedHUD.show(onView: view)
    }
}
