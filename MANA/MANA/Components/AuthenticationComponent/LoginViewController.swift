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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let mainTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.MAIN_TAB_BAR_VIEW_CONTROLLER) as? UITabBarController
                self.view.window?.rootViewController = mainTabBarViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }
}
