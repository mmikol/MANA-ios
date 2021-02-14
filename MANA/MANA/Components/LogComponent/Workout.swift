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
    var date: Date
    var dateString: String
    var photo: UIImage?
    
    init?(name: String, weight: String, date: Date, photo: UIImage?) {
        
        guard !name.isEmpty else {
            return nil
        }

        self.name = name
        self.weight = weight
        self.photo = photo
        self.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateString = dateFormatter.string(from: date)

    }

}
