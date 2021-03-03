//
//  Achievement.swift
//  MANA
//
//  Created by Miliano Mikol on 3/3/21.
//

import Foundation

class Achievement {
    private var name: String
    private var properties: [Property]
    private var unlocked: Bool
    
    init (name: String, properties: [Property]) {
        self.name = name
        self.properties = properties
        self.unlocked = false
    }
}
