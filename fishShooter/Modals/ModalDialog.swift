//
//  ModalDialog.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit

class ModalDialog: SKSpriteNode {
    init(score: Int, size: CGSize, position: CGPoint) {
        super.init(texture: nil, color: .clear, size: size)
        self.position = position
        self.zPosition = 100
        self.isUserInteractionEnabled = true
        setupModal(score: score, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupModal(score: Int, size: CGSize) {
        let background = SKShapeNode(rectOf: size, cornerRadius: 10)
        background.fillColor = UIColor(red: 1.0, green: 0.8, blue: 0.9, alpha: 1.0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 1
        self.addChild(background)

        let resultLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        resultLabel.text = "Final Score: \(score)"
        resultLabel.fontSize = 24
        resultLabel.fontColor = SKColor.white
        resultLabel.position = CGPoint(x: 0, y: 30)
        background.addChild(resultLabel)

        let chooseLevelButton = SKLabelNode(fontNamed: "Chalkboard SE")
        chooseLevelButton.text = "Choose Level"
        chooseLevelButton.fontSize = 24
        chooseLevelButton.fontColor = SKColor.systemPink
        chooseLevelButton.name = "chooseLevelButton"
        chooseLevelButton.position = CGPoint(x: 0, y: -30)
        background.addChild(chooseLevelButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let nodesAtPoint = self.nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "chooseLevelButton" {
                goToChooseLevel()
            }
        }
    }

    func goToChooseLevel() {
        if let scene = ChooseLevel(fileNamed: "ChooseLevel") {
            scene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}

