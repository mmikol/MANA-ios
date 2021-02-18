//
//  Workout+CoreDataProperties.swift
//  
//
//  Created by Miliano Mikol on 2/18/21.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var name: String?
    @NSManaged public var weight: String?
    @NSManaged public var date: Date?

    var dateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self.date!)
        }
}
