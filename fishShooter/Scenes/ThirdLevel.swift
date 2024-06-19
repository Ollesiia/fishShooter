//
//  ThirdLevel.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit
import GameplayKit

class ThirdLevel: BaseLevel {
    override func spawnFishes() {
        let spawningAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                self.spawnFish(speed: 200, spawnInterval: 0.8) // Быстрее и чаще
            },
            SKAction.wait(forDuration: 0.8)
        ]))
        run(spawningAction, withKey: "spawningFishes")
    }
}
