//
//  WorkoutTableViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit
import os.log

class WorkoutTableViewController: UITableViewController {

    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved workouts, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        } else {
            guard let workout1 = Workout(name: "Bench", weight: "225", date: Date(), photo: nil) else {
                fatalError("Unable to instnatiate workout1")
            }
            
            guard let workout2 = Workout(name: "Deadlift", weight: "315", date: Date(), photo: nil) else {
                fatalError("Unable to instnatiate workout1")
            }
            guard let workout3 = Workout(name: "Squat", weight: "315", date: Date(), photo: nil) else {
                fatalError("Unable to instnatiate workout1")
            }
            
            workouts += [workout1, workout2, workout3]
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.WORKOUT_CELL_IDENTIFIER, for: indexPath) as? WorkoutTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutTableViewCell.")
        }

        let workout = workouts[indexPath.row]
        cell.nameLabel.text = workout.name
        cell.weightLabel.text = "\(workout.weight) lbs"
        cell.dateLabel.text = workout.dateString
        
        return cell
    }
    

    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddWorkoutViewController, let workout = sourceViewController.workout {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                workouts[selectedIndexPath.row] = workout
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new workout.
                let newIndexPath = IndexPath(row: workouts.count, section: 0)
                
                workouts.append(workout)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveWorkouts()
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            workouts.remove(at: indexPath.row)
            saveWorkouts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
      
        switch(segue.identifier ?? "") {
        
        case "AddItem":
        os_log("Adding a new workout.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
        guard let workoutDetailViewController = segue.destination as? AddWorkoutViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
         
        guard let selectedWorkoutCell = sender as? WorkoutTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
         
        guard let indexPath = tableView.indexPath(for: selectedWorkoutCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
         
        let selectedWorkout = workouts[indexPath.row]
        
        workoutDetailViewController.workout = selectedWorkout
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
    }
    
    //MARK: Private Methods
    
    private func saveWorkouts() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("workouts")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: workouts, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save workouts...", log: OSLog.default, type: .error)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func loadWorkouts() -> [Workout]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("workouts")
        if let nsData = NSData(contentsOf: fullPath) {
            do {

                let data = Data(referencing:nsData)

                if let loadedWorkouts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Workout> {
                    return loadedWorkouts
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}
