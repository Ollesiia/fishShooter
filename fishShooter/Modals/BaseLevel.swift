//
//  BaseLevel.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit

class BaseLevel: SKScene {
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var backButton: SKShapeNode!
    
    var score: Int = 0
    var startTime: TimeInterval?
    var timeLeft: TimeInterval = 60
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupBackButton()
        setupRightSideLabels()
        spawnFishes()
        startTimer()
    }

    func setupBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1
        backgroundImage.size = self.frame.size
        self.addChild(backgroundImage)
    }

    func setupBackButton() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 20))
        bezierPath.addLine(to: CGPoint(x: 20, y: 40))

        backButton = SKShapeNode(path: bezierPath.cgPath)
        backButton.strokeColor = SKColor.systemPink
        backButton.lineWidth = 4.0
        backButton.fillColor = SKColor.systemPink
        backButton.position = CGPoint(x: self.frame.minX + 70, y: self.frame.maxY - 90)
        backButton.name = "backButton"
        backButton.zPosition = 100
        backButton.isUserInteractionEnabled = false
        self.addChild(backButton)
    }

    func setupRightSideLabels() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.systemPink
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 50)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)

        timerLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        timerLabel.text = "Timer: 60"
        timerLabel.fontSize = 30
        timerLabel.fontColor = SKColor.systemPink
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 100)
        timerLabel.zPosition = 1
        self.addChild(timerLabel)
    }
    
    func endGame() {
        self.removeAction(forKey: "countdown")
        self.removeAction(forKey: "spawningFishes")
        
        let playEndGameSound = SKAction.playSoundFileNamed("endGameSound.wav", waitForCompletion: false)
        self.run(playEndGameSound)
        
        let modalBackground = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.5), size: self.size)
        modalBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        modalBackground.zPosition = 100
        addChild(modalBackground)
        
        let modalWindow = ModalDialog(score: score, size: CGSize(width: 300, height: 200), position: CGPoint(x: frame.midX, y: frame.midY))
        addChild(modalWindow)

        GameScoreManager.shared.bestScore = score
    }

    
    // Override in subclass
    func spawnFishes() {
        fatalError("This method must be overridden")
    }

    func startTimer() {
        startTime = Date().timeIntervalSinceReferenceDate
        run(SKAction.repeatForever(
             SKAction.sequence([
                 SKAction.wait(forDuration: 1),
                 SKAction.run(updateTimer)
             ])
         ), withKey: "countdown")
    }

    func updateTimer() {
        if let startTime = self.startTime {
            timeLeft = 60 - (Date().timeIntervalSinceReferenceDate - startTime)
            
            if timeLeft <= 0 {
                timerLabel?.text = "Time: 0"
                endGame()
            } else {
                timerLabel?.text = "Time: \(Int(timeLeft))"
            }
        }
    }
    
    func spawnFish(speed: CGFloat, spawnInterval: TimeInterval) {
        let fishIndex = Int.random(in: 0...3)
        let fish = SKSpriteNode(imageNamed: "fish\(fishIndex)")
        fish.name = "fish"
        
        let movesLeftToRight = Bool.random()
        let randomY = CGFloat.random(in: 0...size.height - fish.size.height)
        let fishY = randomY - size.height / 2 + fish.size.height / 2
        
        let fishX = movesLeftToRight ? -size.width / 2 - fish.size.width / 2 : size.width / 2 + fish.size.width / 2
        fish.position = CGPoint(x: fishX, y: fishY)
        fish.xScale = movesLeftToRight ? 1 : -1
        fish.zPosition = 1
        addChild(fish)
        
        let distance = size.width + fish.size.width
        let duration = distance / speed
        
        let directionFactor: CGFloat = movesLeftToRight ? 1 : -1
        let moveAction = SKAction.moveBy(x: distance * directionFactor, y: 0, duration: TimeInterval(duration))
        let removeAction = SKAction.removeFromParent()
        fish.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            switch node.name {
            case "backButton":
                goToChooseLevel()
            case "fish":
                handleFishTapped(node)
            default:
                break
            }
        }
    }

    func handleFishTapped(_ node: SKNode) {
        let moveDownAction = SKAction.moveBy(x: 0, y: -size.height / 4, duration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([SKAction.group([moveDownAction, fadeOutAction]), removeAction])
        node.run(sequence)
        
        // Увеличение счета и обновление лейбла счета
        score += 5
        scoreLabel.text = "Score: \(score)"
        
        // Обновление лучшего результата, если текущий счет выше
        ScoreManager.shared.bestScore = score
    }


    func updateBestScoreIfNeeded() {
        if score > GameScoreManager.shared.bestScore {
            GameScoreManager.shared.bestScore = score
        }
    }
    
    func goToChooseLevel() {
        if let scene = ChooseLevel(fileNamed: "ChooseLevel") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }

}

