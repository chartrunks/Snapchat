//
//  PictureViewController.swift
//  Snapchat
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        //Disable next button so they can't keep clicking while it's loading
        nextButton.isEnabled = false
        
        //Uploads image before segue
        
        //Gets folder
        let imagesFolder = Storage.storage().reference().child("images")
        
        //Converts image to data we can use
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        //Makes individual names for each file
        //NSUUID().uuidString
        
        //Uploads data
        imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil) { (metadata, error) in
            print("We tried to upload!")
            if error != nil {
                print("An error occurred:\(error)")
            } else {
                //Perform segue after finished if no errors and sends URL to prepare
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()?.absoluteString)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        
        
    }

}
