//
//  AchievementProperty.swift
//  MANA
//
//  Created by Miliano Mikol on 3/3/21.
//

import Foundation

public class Property {
    private var name: String
    private var value: Int
    private var activation: String
    private var activationValue: Int
    private var initialValue: Int
    
    init(name: String, initialValue: Int, activation: String, activationValue: Int) {
        self.name = name
        self.value = initialValue
        self.initialValue = initialValue
        self.activation = activation
        self.activationValue = activationValue
    }
}
