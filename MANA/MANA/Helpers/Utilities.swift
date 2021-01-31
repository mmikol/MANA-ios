//
//  Utilities.swift
//  MANA
//
//  Created by Miliano Mikol on 1/24/21.
//

import Foundation

class Utilities {
    static func isAcceptedPassword(_ password: String) -> Bool {
        // One capital; One number; 8 characters
        let test = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        return test.evaluate(with: password)
    }
    
}
