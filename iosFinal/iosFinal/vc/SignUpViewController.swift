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
    
    
    @IBOutlet weak var cancleButton: UIButton! { didSet{
        cancleButton.addTarget(self, action: #selector(onCancelButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var choosePhotoButton: UIButton! { didSet{
        choosePhotoButton.addTarget(self, action: #selector(onChoosePhotoButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var createButton: UIButton! { didSet{
        createButton.addTarget(self, action: #selector(onCreateUserPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var profileImagePreview: UIImageView!

    var fullProfilImage : UIImage?
    
    var frDBref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
            //let path = "User/\(currentUser.uid)"
            let desc = self.descriptionTextField.text ?? ""
            let tempDict = AppAction().prepareProfileDictionary(name: username, age: 30, gender: .male , desc: desc)

            AppAction().perform(actionWithType: .updateProfileInfo, targetUid: nil, dict: tempDict)
            
            //upload profilePic to storage (if image exist)
            if let fullImg = self.fullProfilImage{
                AppAction().changeProfilePicture(with: fullImg)
            }
            
            self.creatAccountSuccessfulPopUp(userName: self.usernameTextField.text, email: email)
            
            //avoid logged in directly after account successfully created
            try! FIRAuth.auth()!.signOut()
            
            //TODO: Done creat user go to login page and fill the email
            
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
