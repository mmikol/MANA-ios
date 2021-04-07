//
//  HomeViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//

import UIKit
import Firebase
import Charts

class HomeViewController: UIViewController, UITabBarControllerDelegate, ChartViewDelegate {
    var lineChart = LineChartView()
    
    let database = Firestore.firestore()
    let numberFormatter = NumberFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelProgressBar: UIProgressView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var bestBenchLabel: UILabel!
    @IBOutlet weak var bestSquatLabel: UILabel!
    @IBOutlet weak var bestDeadliftLabel: UILabel!
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
            showUserInformation()
         }
    }

    // REMOVE HARD CODE AFTER TESTS
    private func showUserInformation() {
        if let user = Auth.auth().currentUser {
            let documentReference = database.collection("users").document("K3nMnBjnrMcXndZ5Q5RWjVEVuZo2")
            
            documentReference.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let firstName = data!["first_name"] as? String ?? "<first_name>"
                    let lastName = data!["last_name"] as? String ?? "<last_name>"
                    let level = data!["level"] as? Int ?? 0
                    let currentXP = data!["xp"] as? String ?? "0"
                    let neededXP = self.computeNeededXP(level: level)
                    let levelProgress = (Float(currentXP) ?? 0.0) / Float(neededXP)
                    let bestBench = data!["best_bench"] as? String ?? "0"
                    let bestSquat = data!["best_squat"] as? String ?? "0"
                    let bestDeadlift = data!["best_deadlift"] as? String ?? "0"
                    let bestBenchString = self.numberFormatter.string(from: NSNumber(value: Int(bestBench) ?? 0))
                    let bestSquatString = self.numberFormatter.string(from: NSNumber(value: Int(bestSquat) ?? 0))
                    let bestDeadliftString = self.numberFormatter.string(from: NSNumber(value: Int(bestDeadlift) ?? 0))
                    
                    self.nameLabel.text = "\(firstName) \(lastName)"
                    self.levelLabel.text = "Level \(String(level))"
                    self.xpLabel.text = "XP: \(currentXP) / \(neededXP)"
                    self.bestBenchLabel.text = "\(bestBenchString!) \nlbs"
                    self.bestSquatLabel.text = "\(bestSquatString!) \nlbs"
                    self.bestDeadliftLabel.text = "\(bestDeadliftString!) \nlbs"
                    
                    self.levelProgressBar.setProgress(levelProgress,
                            animated: true)

                  } else {
                     print("Document does not exist")
                  }
            }
        }
    }

    private func computeCurrentXP(level: Int) -> Int {
        let threshold = 50
        return (level^^2 - level) * threshold / 2
    }
    
    private func computeNeededXP(level: Int) -> Int {
        let threshold = 50
        return level * threshold
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .decimal
        showUserInformation()
        self.tabBarController?.delegate = self
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(context)
//        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.fame.size, height: self.view.frame.size)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
}
