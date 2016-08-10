//
//  loginViewController.swift
//  WallaLogin
//
//  Created by Dietrich Tribull on 7/20/16.
//  Copyright © 2016 Dietrich Tribull. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let myUserBackend = UserBackend()
    var hasLoggedIn: Bool = false
    
    //MARK: Text fields
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if checkFieldsValid() {
            self.nativeLogin(self.emailTextField.text!, password: self.passwordTextField.text!)
        }
    }
    
    func nativeLogin(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            print("womp login user callback")
            if let user = user {
                print("user successfully logged in:")
                print(user)
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            }
            else {
                print("user not authenticated properly, see error:")
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func checkFieldsValid() -> Bool {
        return self.emailTextField.text! != "" && self.passwordTextField.text!.characters.count >= 6
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}