//
//  MatchedProfilesViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class MatchedProfilesViewController: UIViewController {

    var matchedUser = [String]()
    var users = [User]()
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchMatchedUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMatchedUser(){
        let uid = AppAction().currentUserUid()
        ref.child("Match").child(uid).observe(.value, with: {(snapshot) in
            
            self.matchedUser = (snapshot.value as? NSDictionary)?.allKeys as? [String] ?? []
            
            DispatchQueue.main.async {
                //self.displayAllUserData()
            }
        })
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
