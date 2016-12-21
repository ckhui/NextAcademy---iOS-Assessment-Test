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
    
    var matchedUserUid = [String]()
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
            
            self.matchedUserUid = (snapshot.value as? NSDictionary)?.allKeys as? [String] ?? []
            
            DispatchQueue.main.async {
                self.users = []
                self.fetchMatchedUserData()
            }
        })
        
    }
    
    func fetchMatchedUserData(){
        ref.child("User").observeSingleEvent(of: .value, with: {(snapshot) in
            if let usersDict = snapshot.value as? [String:AnyObject] {
                
                for userDict in usersDict{
                    let uid = userDict.key
                    
                    if self.matchedUserUid.index(of: uid) != nil {
                        
                        if let dictionary = userDict.value as? [String:AnyObject] {
                            
                            let url = dictionary["picUrl"] as? String ?? nil
                            if let info = dictionary["info"] as? [String:String] {
                                let name = info["name"] as String? ?? ""
                                let age = info["age"] as String? ?? ""
                                let gender = info["gender"] as String? ?? ""
                                let desc = info["desc"] as String? ?? ""
                                
                                let tempUser = User(withUid: uid, userName: name, userAge: age, userGender: gender, userDescription: desc, userPicUrl: url)
                                
                                self.users.append(tempUser)
                            }
                            
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.displayMatchedUserData()
                }
                
            }
        })
    }
    
    func displayMatchedUserData(){
        tableView.reloadData()
        
    }
    
    var selectedUser = User()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMatchedProfile" {
            let vc = segue.destination as! CandidateDetailViewController
            vc.user = selectedUser
            vc.isMatch = true
        }
        
    }
    
}

extension MatchedProfilesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell") as? MatchedUserTableViewCell
            
            else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        if let url = user.profilePicUrl {
            cell.displayImageView.loadImageUsingCacheWithUrlString(url)
        }
        
        cell.descriptionLabel.text = "\(user.name) \(user.age) \(user.gender) \n\(user.description!)"
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        
        performSegue(withIdentifier: "showMatchedProfile", sender: self)
    }
}


extension MatchedProfilesViewController : MatchedUserTableViewCellDelegate {
    func didSwipeLeft(cell: MatchedUserTableViewCell) {
        
        guard let index = tableView.indexPath(for: cell)
            else {
                warningPopUp(withTitle: "Match Error", withMessage: "unable to get target uid")
                return
        }
        let targetuid = users[index.row].uid
        AppAction().perform(actionWithType: .unmatch, targetUid: targetuid)
    }
    
}


