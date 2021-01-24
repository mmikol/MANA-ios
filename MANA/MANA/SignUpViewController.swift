//
//  SignUpViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/22/21.
//

import UIKit
import FirebaseAuth

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
            Auth.auth().createUser(withEmail: <#T##String#>, password: String) { (result, error) in
                if let error = error {
                    showError(error.localizedDescription)
                } else {
                    Firestore.firestore()
                }
            }
        }
        // Create user
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
