//
//  ProfileViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileIamgeView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user = User()
    var ref: FIRDatabaseReference!
    let userUID = AppAction().currentUserUid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        fetchUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserData() {
        ref.child("User").child(userUID).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                print("i")
                
                let url = dictionary["picUrl"] as? String ?? nil
                if let info = dictionary["info"] as? [String:String] {
                    let name = info["name"] as String? ?? ""
                    let age = info["age"] as String? ?? ""
                    let gender = info["gender"] as String? ?? ""
                    let desc = info["desc"] as String? ?? ""
                    
                    self.user = User(withUid: self.userUID, userName: name, userAge: age, userGender: gender, userDescription: desc, userPicUrl: url)
                }
                
                DispatchQueue.main.async {
                    self.displayUserData()
                }
            }
        })
    }
    
    func displayUserData(){
        if let imgUrl = user.profilePicUrl {
            profileIamgeView.loadImageUsingCacheWithUrlString(imgUrl)
        }
        
        nameLabel.text = user.name
        genderLabel.text = String(describing: user.gender)
        ageLabel.text = String(user.age)
        descriptionLabel.text = user.description
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destination as! SignUpViewController
            vc.savedUser = user
            vc.fullProfilImage = profileIamgeView.image
        }
    }
 

}
