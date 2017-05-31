//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Goes through all users
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in

            let user = User()
            
            //Access email
            user.email = (snapshot.value as? NSDictionary)?["email"] as! String
            //Access UID
            user.uid = snapshot.key
            
            self.users.append(user)
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let snap = ["from":user.email, "description":descrip, "imageURL":imageURL, "uuid":uuid]
        
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        //sends them back to root view controller
        navigationController!.popToRootViewController(animated: true)
    }


}
