//
//  WorkoutTableViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit
import OSLog
import CoreData

class WorkoutTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllWorkouts()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func getAllWorkouts() {
        do {
            workouts = try context.fetch(Workout.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch let error {
            print("\(error)")
        }
    }
    
    func store(workout: Workout) {
        let newWorkout = Workout(context: context)
           
        newWorkout.name = workout.name
        newWorkout.weight = workout.weight
        newWorkout.date = workout.date
            
        do {
            try context.save()
            getAllWorkouts()
        }
        catch let error {
            print("\(error)")
        }
    }
    
    func delete(workout: Workout) {
        context.delete(workout)
        
        do {
            try context.save()
            getAllWorkouts()
        }
        catch let error {
            print("\(error)")
        }
    }
    
    func update(workout: Workout, name: String, weight: String, date: Date) {
        workout.name = name
        workout.weight = weight
        workout.date = date
        
        do {
            try context.save()
            getAllWorkouts()
        }
        catch let error {
            print("\(error)")
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
        cell.weightLabel.text = "\(workout.weight!) lbs"
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
                
                store(workout: workout)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            delete(workout: workouts[indexPath.row])
//            workouts.remove(at: indexPath.row)
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
    
}
