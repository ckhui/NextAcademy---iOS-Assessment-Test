//
//  LoginViewController.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton! { didSet{
        signupButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var loginButton: UIButton! { didSet{
        loginButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)    }}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkLoggedInUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonTapped(button: UIButton)
    {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text
            else
        {   // warn user that they need to enter username or password
            
            self.warningPopUp(withTitle: "Error", withMessage: "email and name error")
            return
        }
        
        //TODO : validate empty input
        //TODO: check email format
        
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: {(user, error) in
            //if no error and user exist
            if let authError = error {
                //display the error
                print("login error \(authError)")
                self.warningPopUp(withTitle: "Log in Error", withMessage: "password and email not match : \(authError)")
                return
            }
            
            self.notifySuccessLogin()
        })
    }


    func createAccountButtonTapped(button: UIButton){
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }

    
    func checkLoggedInUser(){
        if FIRAuth.auth()?.currentUser == nil{
            print("No user right now, you can login")
        }
        else{
            print("there ald some user, sorry")
            notifyExistLoggedInUser()
        }
    }
    
    func notifySuccessLogin ()
    {
        let AuthSuccessNotification = Notification (name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(AuthSuccessNotification)
    }
    
    func notifyExistLoggedInUser ()
    {
        let ExistLoggedInUserNotification = Notification (name: Notification.Name(rawValue: "ExistLoggedInUserNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(ExistLoggedInUserNotification)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSignUpPage"){
            return
        }
    }

    
}
