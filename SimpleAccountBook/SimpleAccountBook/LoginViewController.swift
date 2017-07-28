//
//  LoginViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-13.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var user: FIRUser!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordField.isSecureTextEntry = true
        user = FIRAuth.auth()?.currentUser
        
        if user != nil {
            print("User is signed in.")
            emailField.text = user?.email
            passwordField.becomeFirstResponder()
        } else {
            print("No user is signed in.")
            emailField.becomeFirstResponder()
        }
        
        
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {

        let email = emailField.text
        let password = passwordField.text
        
        if password != "" && email != "" {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                guard let _ = user else {
                    if let error = error {
                        if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                            switch errCode {
                            case .errorCodeUserNotFound:
                                self.showAlert("User account not found. Try registering")
                            case .errorCodeWrongPassword:
                                self.showAlert("Incorrect username/password combination")
                            default:
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                        return
                    }
                    assertionFailure("user and error are nil")
                    return
                }
                self.signIn()
            })
        } else {
            self.showAlert("Input Email & Password")
        }
    }
    
    @IBAction func didTapSignup(_ sender: Any) {
        performSegue(withIdentifier: "RegisterID", sender: nil)
    }
    
    @IBAction func didTapLoginAnotherAccount(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
//            performSegue(withIdentifier: "SignOut", sender: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }

    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "LoginFromSignin", sender: nil)
    }

}
