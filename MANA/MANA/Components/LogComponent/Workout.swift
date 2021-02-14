//
//  Workout.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit
import os.log

class Workout : NSObject, NSCoding {
    //MARK: Properties
    
    struct PropertyKey {
        static let name = "name"
        static let weight = "weight"
        static let date = "date"
        static let photo = "photo"
    }

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
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")

    //MARK: NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(name, forKey: PropertyKey.weight)
        coder.encode(name, forKey: PropertyKey.date)
        coder.encode(name, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let weight = coder.decodeObject(forKey: PropertyKey.weight) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let date = coder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }

        // let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(name: name, weight: weight, date: date, photo: nil)
    }
}
