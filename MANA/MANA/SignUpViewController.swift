//
//  SignUpViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/22/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    func validateFields() -> String? {
        // All fields filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "All fields required."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Password is secure
        if !Utilities.isAcceptedPassword(cleanedPassword) {
            return "Password must contain: One capital; One number; 8 characters."
        
        }
        
        return nil
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.showError(error.localizedDescription)
                } else {
                    let database = Firestore.firestore()
                    database.collection("users").addDocument(
                        data: [
                            "firstname": firstName,
                            "lastname": lastName,
                            "uid": result!.user.uid
                        ]) { (error) in
                        if error != nil {
                            self.showError(error!.localizedDescription)
                        }
                    }
                }
            }
        }
        //Transition to home screen
    }
    
    func showError(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        // Add styles for tapping the button
    }
}
