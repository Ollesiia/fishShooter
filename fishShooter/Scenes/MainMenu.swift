//
//  MainMenu.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupLabels()
    }
    
    // добавить задний фон для кнопок
    
    func setupBackground() {
        // Load the background image
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1  // Ensures the background is behind all other nodes
        backgroundImage.size = self.frame.size  // Adjust size to fit the screen
        self.addChild(backgroundImage)
    }
    
    func setupLabels() {
        // Start button label
        let startLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        startLabel.text = "Start"
        startLabel.fontSize = 50
        startLabel.fontColor = SKColor.systemPink
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        startLabel.name = "startButton"
        self.addChild(startLabel)

        // View results label
        let resultsLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        resultsLabel.text = "View Results"
        resultsLabel.fontSize = 50
        resultsLabel.fontColor = SKColor.systemPink
        resultsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 90)
        resultsLabel.name = "resultsButton"
        self.addChild(resultsLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "startButton" {
                switchToGameScene()
            } else if node.name == "resultsButton" {
                showBestScoreDialog()
            }
        }
    }

    func switchToGameScene() {
        if let scene = ChooseLevel(fileNamed: "ChooseLevel") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }

    func showBestScoreDialog() {
        let bestScoreDialog = BestScoreDialog(size: CGSize(width: 350, height: 250))
        bestScoreDialog.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bestScoreDialog)
    }
}

