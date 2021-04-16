//
//  AchievementBlackBox.swift
//  MANA
//
//  Created by Miliano Mikol on 3/3/21.
//

import Foundation

public class AchievementBlackBox {
    // Activation rules
    let ACTIVE_IF_GREATER_THAN = ">"
    let ACTIVE_IF_LESS_THAN = "<"
    let ACTIVE_IF_EQUALS_TO = "=="
   
    private var properties: [String: Property] = [:]
    private var achievements: [String: Achievement] = [:]
}
