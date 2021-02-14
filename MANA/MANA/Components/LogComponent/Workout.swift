//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit

class Workout {
    var name: String
    var weight: Int
    var reps: Int
    var date: String
    var photo: UIImage?
    
    init?(name: String, weight: Int, reps: Int, date: Date, photo: UIImage?) {
        
        guard !name.isEmpty else {
            return nil
        }

        self.name = name
        self.weight = weight
        self.reps = reps
        self.photo = photo
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.date = df.string(from: date)

    }

}
