//
//  LoginViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/22/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
 
    @IBAction func loginButtonTapped(_ sender: Any) {
        // TODO: Validate fields same as sign up

        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.HOME_VIEW_CONTROLLER) as? HomeViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
        
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
