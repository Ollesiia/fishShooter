//
//  ChooseLevel.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit

class ChooseLevel: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLevelButtons()
        setupBackButton()
    }
    
    func setupBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1
        backgroundImage.size = self.frame.size
        self.addChild(backgroundImage)
    }
    
    func setupLevelButtons() {
        let buttonNames = ["Easy Level", "Medium Level", "Hard Level"]
        let buttonSpacing: CGFloat = 70
        let firstButtonY = self.frame.midY + buttonSpacing + 50
        
        for (index, name) in buttonNames.enumerated() {
            let levelButton = SKLabelNode(fontNamed: "Chalkboard SE")
            levelButton.text = name
            levelButton.fontSize = 50
            levelButton.fontColor = SKColor.systemPink
            levelButton.position = CGPoint(x: self.frame.midX, y: firstButtonY - CGFloat(index) * buttonSpacing * 2)
            levelButton.name = name.replacingOccurrences(of: " ", with: "")
            levelButton.zPosition = 100
            self.addChild(levelButton)
        }
    }

    
    func setupBackButton() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 20))
        bezierPath.addLine(to: CGPoint(x: 20, y: 40))

        let backButton = SKShapeNode(path: bezierPath.cgPath)
        backButton.strokeColor = SKColor.systemPink
        backButton.lineWidth = 4.0
        backButton.fillColor = SKColor.systemPink
        backButton.position = CGPoint(x: self.frame.minX + 70, y: self.frame.maxY - 90)
        backButton.name = "backButton"
        backButton.zPosition = 100
        backButton.isUserInteractionEnabled = false
        self.addChild(backButton)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            if let nodeName = node.name {
                switch nodeName {
                case "EasyLevel":
                    startGame(level: .easy)
                case "MediumLevel":
                    startGame(level: .medium)
                case "HardLevel":
                    startGame(level: .hard)
                case "backButton":
                    goToMainMenu()
                default:
                    break
                }
            }
        }
    }
    
    func startGame(level: GameLevel) {
        var scene: SKScene?
        switch level {
        case .easy:
            scene = FirstLevel(fileNamed: "FirstLevel")
        case .medium:
            scene = SecondLevel(fileNamed: "SecondLevel")
        case .hard:
            scene = ThirdLevel(fileNamed: "ThirdLevel")
        }
        
        if let scene = scene {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
            print("Starting game at \(level) level.")
        }
    }

    func goToMainMenu() {
        if let scene = MainMenu(fileNamed: "MainMenu") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    enum GameLevel {
        case easy, medium, hard
    }
}


