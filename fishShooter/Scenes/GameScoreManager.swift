//
//  GameScoreManager.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation

class GameScoreManager {
    static let shared = GameScoreManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let key = "bestScore"

    var bestScore: Int {
        get { defaults.integer(forKey: key) }
        set {
            if newValue > bestScore {
                defaults.set(newValue, forKey: key)
            }
        }
    }
}


