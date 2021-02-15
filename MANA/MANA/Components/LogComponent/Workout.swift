//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit
import os.log

class Workout  {
    //MARK: Types
     
    enum CodingKeys: String, CodingKey {
        case name
        case weight
        case date
        case location
    }

    struct PropertyKey {
        static let name = "name"
        static let weight = "weight"
        static let date = "date"
        static let photo = "photo"
    }

    //MARK: Properties
    var name: String
    var weight: String
    var date: Date
    var photo: UIImage?
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    init?(name: String, weight: String, date: Date, photo: UIImage?) {
        guard !name.isEmpty && !weight.isEmpty else {
            return nil
        }

        self.name = name
        self.weight = weight
        self.photo = photo
        self.date = date
    }
}
