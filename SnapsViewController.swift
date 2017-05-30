//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SnapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil) //For getting rid of a view controller called modally
    }
    

}
