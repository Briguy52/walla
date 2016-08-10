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
    
    //MARK: Text fields
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        if checkFieldsValid() {
            self.myUserBackend.nativeLogin(self.emailTextField.text!, password: self.passwordTextField.text!)
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    print("user is signed in!")
                    self.performSegueWithIdentifier("loggedInSegue", sender: self)
                } else {
                    print("no user signed in")
                }
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