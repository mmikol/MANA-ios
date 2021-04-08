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
    let database = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let numberFormatter = NumberFormatter()
    
    var lineChart = LineChartView()
    
    @IBOutlet weak var benchChartButton: UIButton!
    @IBOutlet weak var squatChartButton: UIButton!
    @IBOutlet weak var deadliftChartButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelProgressBar: UIProgressView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var bestBenchLabel: UILabel!
    @IBOutlet weak var bestSquatLabel: UILabel!
    @IBOutlet weak var bestDeadliftLabel: UILabel!

    @IBAction func benchChartButtonTapped(_ sender: Any) {
        guard benchChartButton.isSelected else {
            benchChartButton.isSelected.toggle()
            generateChart()
            if squatChartButton.isSelected {
                squatChartButton.isSelected.toggle()
            } else if deadliftChartButton.isSelected {
                deadliftChartButton.isSelected.toggle()
            }
            return
        }
    }

    @IBAction func squatChartButtonTapped(_ sender: Any) {
        guard squatChartButton.isSelected else {
            squatChartButton.isSelected.toggle()
            generateChart()
            if benchChartButton.isSelected {
                benchChartButton.isSelected.toggle()
            } else if deadliftChartButton.isSelected {
                deadliftChartButton.isSelected.toggle()
            }
            return
        }
    }
    
    @IBAction func deadliftChartButtonTapped(_ sender: Any) {
        guard deadliftChartButton.isSelected else {
            deadliftChartButton.isSelected.toggle()
            generateChart()
            if benchChartButton.isSelected {
                benchChartButton.isSelected.toggle()
            } else if squatChartButton.isSelected {
                squatChartButton.isSelected.toggle()
            }
            return
        }
    }
    
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
                    self.levelProgressBar.setProgress(levelProgress, animated: true)
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
        benchChartButton.isSelected = true
        numberFormatter.numberStyle = .decimal
        showUserInformation()
        self.tabBarController?.delegate = self
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lineChart.noDataText = "No Chart data found. Time to lift!"
        lineChart.frame = CGRect(x: 0, y: view.center.y - 250, width: self.view.frame.size.width, height: 300)
        view.addSubview(lineChart)
        generateChart()
    }
    
    private func generateChart() {
        var workouts: [Workout]
        var entries = [ChartDataEntry]()

        do {
            workouts = try context.fetch(Workout.fetchRequest())
            
            if benchChartButton.isSelected {
                workouts.filter { workout in
                            workout.name == "Bench Press"
                        }
                        .enumerated()
                        .forEach { (count, workout) in
                            entries.append(ChartDataEntry(x: Double(workout.weight!) ?? 0, y: Double(count)))
                        }
            } else if squatChartButton.isSelected {
                workouts.filter { workout in
                            workout.name == "Squat"
                        }
                        .enumerated()
                        .forEach { (count, workout) in
                            entries.append(ChartDataEntry(x: Double(workout.weight!) ?? 0, y: Double(count)))
                        }
            } else if deadliftChartButton.isSelected {
                workouts.filter { workout in
                            workout.name == "Deadlift"
                        }
                        .enumerated()
                        .forEach { (count, workout) in
                            entries.append(ChartDataEntry(x: Double(workout.weight!) ?? 0, y: Double(count)))
                        }
            }
        } catch let error {
            print("\(error)")
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
}
