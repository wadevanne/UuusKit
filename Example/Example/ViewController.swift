//
//  ViewController.swift
//  Example
//
//  Created by 范炜佳 on 18/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let a = Date()
//        let b = Date(timeInterval: 10, since: a)
//        let c = Date(timeInterval: 69, since: a)
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
//                print("b: ", b.timestamp.history as Any)
//                print("c: ", c.timestamp.history as Any)
//                print("v: ", Date.daysLater(rayka: b.timestamp, end: c.timestamp))
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

