//
//  ViewController.swift
//  ATAlertService
//
//  Created by yebiaoli on 02/06/2025.
//  Copyright (c) 2025 yebiaoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickDemo1(_ sender: Any) {
        let vctl = ViewController2()
        navigationController?.pushViewController(vctl, animated: true)
    }
}

