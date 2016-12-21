//
//  CandidateDetailViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit

class CandidateDetailViewController: UIViewController {
    
    var user : User?
    var isMatch = false
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var matchingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            if let url = user.profilePicUrl{
                profileImageView.loadImageUsingCacheWithUrlString(url)
            }
            nameLabel.text = user.name
            ageLabel.text = String(user.age)
            genderLabel.text = user.gender.rawValue
            descriptionLabel.text = user.description
        }

        
        setMatchButtonTitle()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMatchButtonTitle() {
        if isMatch {
            matchingButton.setTitle("Unmatch", for: .normal)
        }else {
            matchingButton.setTitle("Match", for: .normal)
        }
        isMatch = !isMatch
    }
    
    @IBAction func mathcButtonPressed(_ sender: Any) {
        if isMatch{
            AppAction().perform(actionWithType: .unmatch, targetUid: user?.uid)
        } else {
            AppAction().perform(actionWithType: .match , targetUid: user?.uid)
        }
        setMatchButtonTitle()
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
