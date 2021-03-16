//
//  HomeViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITabBarControllerDelegate {
    let database = Firestore.firestore()
    
    @IBOutlet weak var bestBenchLabel: UILabel!
    @IBOutlet weak var bestSquatLabel: UILabel!
    @IBOutlet weak var bestDeadliftLabel: UILabel!
   
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
            showPersonalBests()
         }
    }

    // REMOVE HARD CODE AFTER TESTS
    private func showPersonalBests() {
        if let user = Auth.auth().currentUser {
            let documentReference = database.collection("users").document("K3nMnBjnrMcXndZ5Q5RWjVEVuZo2")
            
            documentReference.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.bestBenchLabel.text = data!["best_bench"] as? String ?? ""
                    self.bestSquatLabel.text = data!["best_squat"] as? String ?? ""
                    self.bestDeadliftLabel.text = data!["best_deadlift"] as? String ?? ""
                  } else {
                     print("Document does not exist")
                  }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
