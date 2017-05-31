//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //Goes through all snaps when snap is added
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let snap = Snap()
            snap.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["description"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value as! NSDictionary)["uuid"] as! String
            
            self.snaps.append(snap)
            
            self.tableView.reloadData()
            })
        
        //Goes through all snaps when snap is removed
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
        })
    }

    @IBAction func logOutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil) //For getting rid of a view controller called modally
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let snap = snaps[indexPath.row]
        
        cell.textLabel?.text = snap.from
        
        return cell
    }
    
    //performs segue and makes snap sender
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    //sets snap in next story board to sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //view controller has two segues so only runs this when we go to viewsnap
        if segue.identifier == "viewSnapSegue" {
        let nextVC = segue.destination as! ViewSnapViewController
        nextVC.snap = sender as! Snap
        }
    }
    

}
