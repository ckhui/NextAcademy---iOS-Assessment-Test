//
//  SingUpViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    
    @IBOutlet weak var cancleButton: UIButton! { didSet{
        cancleButton.addTarget(self, action: #selector(onCancelButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var choosePhotoButton: UIButton! { didSet{
        choosePhotoButton.addTarget(self, action: #selector(onChoosePhotoButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var createButton: UIButton! { didSet{
        createButton.addTarget(self, action: #selector(onCreateUserPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var profileImagePreview: UIImageView!
    
    var fullProfilImage : UIImage?
    
    var frDBref: FIRDatabaseReference!
    
    var savedUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = savedUser {
            usernameTextField.text = user.name
            emailTextField.isHidden = true
            passwordTextField.isHidden = true
            ageLabel.text = String(user.age)
            genderLabel.text = user.gender.rawValue
            descriptionTextField.text = user.description
            createButton.setTitle("Update Account", for: .normal)
            
        } else {
            fullProfilImage = UIImage(named: "profile")
        }
        
        profileImagePreview.image = fullProfilImage
        profileImagePreview.layer.borderWidth = 3.0
        profileImagePreview.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCreateUserPressed(button: UIButton) {
        //TODO : more specific email and username validation, regular expression
        //TODO: age gender
        
        let username = usernameTextField.text ?? ""
        if username == ""{
            warningPopUp(withTitle: "Username", withMessage: "Cannot be empty")
            return
        }
        
        let age = ageLabel.text ?? ""
        let gender = genderLabel.text ?? ""
        
        guard let ageNumber = Int(age)
            else {
                warningPopUp(withTitle: "input error", withMessage: "invalid age")
                return
        }
        if gender != "male"  && gender != "female" {
            warningPopUp(withTitle: "input error", withMessage: "gender only allow: male/fe")
            return
        }
        
        //let path = "User/\(currentUser.uid)"
        let desc = self.descriptionTextField.text ?? ""
        var sex = genderType.none
        if gender == "male"{
            sex = .male
        }else if gender == "female" {
            sex = .female
        }
        let tempDict = AppAction().prepareProfileDictionary(name: username, age: ageNumber, gender: sex , desc: desc)
        AppAction().perform(actionWithType: .updateProfileInfo, targetUid: nil, dict: tempDict)
        
        if savedUser == nil {
            
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            
            if email == "" || password == ""{
                warningPopUp(withTitle: "input error", withMessage: "empty email or password")
                return
            }
            
            
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                //TODO: if email ald exist
                if let createAccountError = error {
                    print("Creat Account error : \(createAccountError)")
                    self.warningPopUp(withTitle: "Creat Account error ", withMessage: "\(createAccountError)")
                    return
                }
                
                guard let currentUser = user else{
                    print ("impossible current user not found error")
                    return
                }
                
                //creat account
                
                //upload profilePic to storage (if image exist)
                if let fullImg = self.fullProfilImage{
                    AppAction().changeProfilePicture(with: fullImg, userUid: currentUser.uid)
                }
                
                self.creatAccountSuccessfulPopUp(userName: self.usernameTextField.text, email: email)
                
                //avoid logged in directly after account successfully created
                try! FIRAuth.auth()!.signOut()
                
                //TODO: Done creat user go to login page and fill the email
                
            }
        }
        
        print("created process done")
        
        //go back
        dismiss(animated: true, completion: nil)
    }
    
    
    func creatAccountSuccessfulPopUp(userName: String?,email: String?){
        let message = "Account creted with \nUsername : \(userName) \nEmail : \(email)"
        let title = "Account Successful Create"
        warningPopUp(withTitle: title, withMessage: message)
    }
    
    func onCancelButtonTapped(button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func onChoosePhotoButtonPressed(button: UIButton) {
        //        let vc = imagepickerViewController()
        //        vc.delegate = self
        //        present(vc, animated: true, completion: nil)
        
        performSegue(withIdentifier: "signInToSelectPhoto", sender: self)
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
