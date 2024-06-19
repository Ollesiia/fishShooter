//
//  ScoreManager.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation

class ScoreManager {
    static let shared = ScoreManager()

    private let defaults = UserDefaults.standard
    private let bestScoreKey = "bestScore"

    private init() {}

    var bestScore: Int {
        get {
            return defaults.integer(forKey: bestScoreKey)
        }
        set {
            if newValue > bestScore {
                defaults.set(newValue, forKey: bestScoreKey)
            }
        }
    }
}
