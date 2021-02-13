//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit

class Workout {
    var name: String
    var date: Date
    var weight: Int
    var reps: Int
    var photo: UIImage?

    init?(name: String, date: Date, weight: Int, reps: Int, photo: UIImage?) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.date = date
        self.weight = weight
        self.reps = reps
        self.photo = photo
    }

}

