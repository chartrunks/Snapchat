//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imageURL))
    }
    
    //Runs every time we leave the view snap view controller (hit back button)
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.key).removeValue()
        
        Storage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
            print("We deleted the picture.")
        }
    }

}
