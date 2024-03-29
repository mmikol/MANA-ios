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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.showError(error.localizedDescription)
                } else {
                    let database = Firestore.firestore()
            
                    database.collection("users").addDocument(
                        data: [
                            "first_name": firstName,
                            "last_name": lastName,
                            "best_squat": "0",
                            "best_deadlift": "0",
                            "best_bench": "0",
                            "level": 0
                        ]) { (error) in
                        if error != nil {
                            self.showError(error!.localizedDescription)
                        }
                    }
                }
            }
        }

        self.transitionToHome()
    }
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "All fields required."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !isAcceptedPassword(cleanedPassword) {
            return "Password must contain 8 characters with one capital letter and one number."
        
        }
        
        return nil
    }

    func showError(_ error: String!) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let mainTabBarViewController = storyboard?.instantiateViewController(withIdentifier: Constants.MAIN_TAB_BAR_VIEW_CONTROLLER) as? UITabBarController
        view.window?.rootViewController = mainTabBarViewController
        view.window?.makeKeyAndVisible()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func isAcceptedPassword(_ password: String) -> Bool {
        // One capital; One number; 8 characters
        let test = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        return test.evaluate(with: password)
    }
}
