//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit

class Workout {
    //MARK: Properties
    var name: String
    var weight: String
    var date: Date
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    init?(name: String, weight: String, date: Date) {
        guard !name.isEmpty && !weight.isEmpty else {
            return nil
        }

        self.name = name
        self.weight = weight
        self.date = date
    }
}
