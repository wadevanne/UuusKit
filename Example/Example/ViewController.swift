//
//  ViewController.swift
//  Example
//
//  Created by 范炜佳 on 18/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UuusKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController!.view.backgroundColor = .white

        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            }
        } else {
            // Fallback on earlier versions
        }

        button.image2Right(boundedUpright: button.frame.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var button: UIButton!

    @IBAction func action(_: UIButton) {
    }
}
