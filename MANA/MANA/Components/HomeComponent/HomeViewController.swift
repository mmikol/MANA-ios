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

    var workouts = [Workout]()
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        benchChartButton.isSelected = true
        benchChartButton.backgroundColor = #colorLiteral(red: 0.9883286357, green: 0.7884005904, blue: 0, alpha: 1)
        benchChartButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .selected)
        squatChartButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .selected)
        deadliftChartButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .selected)
        numberFormatter.numberStyle = .decimal
        showUserInformation()
        self.tabBarController?.delegate = self
        lineChart.delegate = self
        levelProgressBar.transform = levelProgressBar.transform.scaledBy(x: 1, y: 10)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupChart()
        generateChart()
    }

    @IBAction func benchChartButtonTapped(_ sender: Any) {
        guard benchChartButton.isSelected else {
            benchChartButton.isSelected.toggle()
            benchChartButton.backgroundColor = #colorLiteral(red: 0.9883286357, green: 0.7884005904, blue: 0, alpha: 1)
            if squatChartButton.isSelected {
                squatChartButton.isSelected.toggle()
                squatChartButton.backgroundColor =  UIColor.clear
            } else if deadliftChartButton.isSelected {
                deadliftChartButton.isSelected.toggle()
                deadliftChartButton.backgroundColor = UIColor.clear
            }
            generateChart()
            return
        }
    }

    @IBAction func squatChartButtonTapped(_ sender: Any) {
        guard squatChartButton.isSelected else {
            squatChartButton.isSelected.toggle()
            squatChartButton.backgroundColor =  #colorLiteral(red: 0.08806554228, green: 0.5374518037, blue: 0.789417088, alpha: 1)
            if benchChartButton.isSelected {
                benchChartButton.isSelected.toggle()
                benchChartButton.backgroundColor = UIColor.clear
            } else if deadliftChartButton.isSelected {
                deadliftChartButton.isSelected.toggle()
                deadliftChartButton.backgroundColor = UIColor.clear
            }
            generateChart()
            return
        }
    }
    
    @IBAction func deadliftChartButtonTapped(_ sender: Any) {
        guard deadliftChartButton.isSelected else {
            deadliftChartButton.isSelected.toggle()
            deadliftChartButton.backgroundColor = #colorLiteral(red: 0.9852438569, green: 0, blue: 0, alpha: 1)
            if benchChartButton.isSelected {
                benchChartButton.isSelected.toggle()
                benchChartButton.backgroundColor = UIColor.clear
            } else if squatChartButton.isSelected {
                squatChartButton.isSelected.toggle()
                squatChartButton.backgroundColor =  UIColor.clear
            }
            generateChart()
            return
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
            showUserInformation()
         }
    }

    private func showUserInformation() {
        if let user = Auth.auth().currentUser {
            let documentReference = database.collection("users").document(user.uid)
            
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
                    
                    self.navigationItem.title = "\(firstName) \(lastName)"
                    self.levelLabel.text = "Level \(String(level))"
                    self.xpLabel.text = "\(currentXP) / \(neededXP) XP"
                    self.bestBenchLabel.text = "\(bestBenchString!) \nLB"
                    self.bestSquatLabel.text = "\(bestSquatString!) \nLB"
                    self.bestDeadliftLabel.text = "\(bestDeadliftString!) \nLB"
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

    private func setupChart() {
        lineChart.noDataTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lineChart.noDataFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        lineChart.noDataText = "No chart data found. Start grinding!"
        lineChart.frame = CGRect(x: 0, y: view.center.y - 265, width: self.view.frame.size.width, height: 300)
        view.addSubview(lineChart)
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.rightAxis.drawLabelsEnabled = false
        lineChart.drawBordersEnabled = false
        lineChart.legend.enabled = false
        lineChart.xAxis.axisLineColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lineChart.rightAxis.gridColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lineChart.borderColor = UIColor.clear
    }
    
    private func generateChart() {
        if !lineChart.isEmpty() {
            lineChart.clear()
        }
        
        do {
            workouts = try context.fetch(Workout.fetchRequest())
        } catch let error {
            print("\(error)")
        }

        var entries = [ChartDataEntry]()
        var xCoordinate = 0.0
        
        if benchChartButton.isSelected {
            for workout in workouts {
                if (workout.name == "Bench Press") {
                    entries.append(ChartDataEntry(x: xCoordinate, y: Double(workout.weight!) ?? 0))
                    xCoordinate += 1.0
                }
            }
            if entries.count > 0 {
                drawChart(with: entries)
            }
        } else if squatChartButton.isSelected {
            for workout in workouts {
                if (workout.name == "Squat") {
                    entries.append(ChartDataEntry(x: xCoordinate, y: Double(workout.weight!) ?? 0))
                    xCoordinate += 1.0
                }
            }
            if entries.count > 0 {
                drawChart(with: entries)
            }
        } else if deadliftChartButton.isSelected {
            for workout in workouts {
                if (workout.name == "Deadlift") {
                    entries.append(ChartDataEntry(x: xCoordinate, y: Double(workout.weight!) ?? 0))
                    xCoordinate += 1.0
                }
            }
            
            if entries.count > 0 {
                drawChart(with: entries)
            }
        }
    }
    
    private func drawChart(with entries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: entries.isEmpty ? [ChartDataEntry]() : entries)

        let strongGradientColor = (
            benchChartButton.isSelected ? #colorLiteral(red: 0.9207075238, green: 0.832200706, blue: 0.2110097706, alpha: 1) :
            squatChartButton.isSelected ? #colorLiteral(red: 0.08806554228, green: 0.5374518037, blue: 0.789417088, alpha: 1):
            deadliftChartButton.isSelected ? #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) : UIColor.clear.cgColor
        )
        let gradientColors = [strongGradientColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else {
            print("Gradient error occurred")
            return
        }

        if benchChartButton.isSelected {
            let color = ChartColorTemplates.colorFromString("rgb(231, 213, 87)")
            set.colors = [color]
        } else if squatChartButton.isSelected {
            let color = ChartColorTemplates.colorFromString("rgb(64, 135, 196)")
            set.colors = [color]
        } else if deadliftChartButton.isSelected {
            let color = ChartColorTemplates.colorFromString("rgb(235, 51, 35)")
            set.colors = [color]
        }

        set.setCircleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        set.valueTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        set.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        set.drawFilledEnabled = true
        lineChart.data = LineChartData(dataSet: set)
    }
}
