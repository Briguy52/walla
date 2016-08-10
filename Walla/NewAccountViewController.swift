//
//  NewAccountViewController.swift
//  WallaLogin
//
//  Created by Dietrich Tribull on 7/21/16.
//  Copyright © 2016 Dietrich Tribull. All rights reserved.
//

import UIKit


class NewAccountViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let myUserBackend = UserBackend()
    
    //MARK: Text Fields
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initEmptyStrings() // inits text fields with ""
        self.formatProfilePic()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.formatProfilePic()
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        firstNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initEmptyStrings() {
        self.emailTextField.text = ""
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    func checkFieldsValid() -> Bool {
        var email = self.emailTextField.text!
        var first = self.firstNameTextField.text!
        var last = self.lastNameTextField.text!
        var pass = self.passwordTextField.text!
        
        var array = [email, first, last, pass]
        for field in array {
            if field == "" {
                return false
            }
        }
        // Firebase requires passwords of at least six characters
        if pass.characters.count < 6 {
            return false
        }
        
        return true
    }
    
    func formatProfilePic() {
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 3
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.borderWidth = 3.0
        self.photoImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if (checkFieldsValid()) {
            self.myUserBackend.nativeCreateUser(self.emailTextField.text!, password: self.passwordTextField.text!, displayName: self.firstNameTextField.text!, name: self.firstNameTextField.text! + " " + self.lastNameTextField.text!)
            
            self.performSegueWithIdentifier("signedUpSegue", sender: self)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signedUpSegue" {
            print("signed up")
        }
    }
    
}