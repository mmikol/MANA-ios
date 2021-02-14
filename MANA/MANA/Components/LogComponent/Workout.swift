//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit

class Workout {
    var name: String
    var weight: String
    var date: String
    var photo: UIImage?
    
    init?(name: String, weight: String, date: Date, photo: UIImage?) {
        
        guard !name.isEmpty else {
            return nil
        }

        self.name = name
        self.weight = weight
        self.photo = photo
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.date = df.string(from: date)

    }

}
