//
//  ExploreViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ExploreViewController: UIViewController {
    
    
    var users = [User]()
    var filteredUsers = [User]()
    
    var matchedUser = [String]()
    
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
                self.matchedUser.append(uid)
                self.fetchMatchedUser()
            }
        })
        
    }
    
    func fetchAllUserData(){
        
        ref.child("User").observeSingleEvent(of: .value, with: {(snapshot) in
            if let usersDict = snapshot.value as? [String:AnyObject] {
                
                for userDict in usersDict{
                    let uid = userDict.key
                    
                    if self.matchedUser.index(of: uid) == nil {
                        
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
                    self.displayAllUserData()
                }
                
            }
        })
        
    }
    
    func displayAllUserData(){
        filteredUsers = users
        tableView.reloadData()
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

extension ExploreViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell") as? CandidateTableViewCell
            else { return UITableViewCell() }
        
        let user = filteredUsers[indexPath.row]
        if let url = user.profilePicUrl {
            cell.displayImageView.loadImageUsingCacheWithUrlString(url)
        }
        
        cell.descriptionLabel.text = "\(user.name) \(user.age) \(user.gender) \n\(user.description!)"
        
        cell.delegate = self
        
        return cell
    }
    
}

extension ExploreViewController : CandidateTableViewCellDelegate {
    func didTapMatch(atCell cell: CandidateTableViewCell) {
        
        guard let index = tableView.indexPath(for: cell)
            else {
                warningPopUp(withTitle: "Match Error", withMessage: "unable to get target uid")
                return
        }
        let targetuid = filteredUsers[index.row].uid
        AppAction().perform(actionWithType: .match, targetUid: targetuid)
    }
}
