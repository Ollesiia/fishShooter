//
//  BestScoreDialog.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import SpriteKit

class BestScoreDialog: SKSpriteNode, UIViewControllerTransitioningDelegate {
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        self.isUserInteractionEnabled = true
        setupBestScoreModal(position: CGPoint.zero)
        appearAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBestScoreModal(position: CGPoint) {
        self.position = position
        self.zPosition = 100
        
        let background = SKShapeNode(rectOf: self.size, cornerRadius: 20)
        background.fillColor = UIColor(red: 1.0, green: 0.8, blue: 0.9, alpha: 1.0)
        background.zPosition = 1
        background.isUserInteractionEnabled = false
        self.addChild(background)

        let bestScore = ScoreManager.shared.bestScore
            
        let bestScoreLabel = SKLabelNode(fontNamed: "Chalkboard SE")
        bestScoreLabel.text = "Your Best Score: \(bestScore)"
        bestScoreLabel.fontSize = 28
        bestScoreLabel.fontColor = SKColor.white
        bestScoreLabel.position = CGPoint(x: 0, y: 60)
        background.addChild(bestScoreLabel)

        let saveResultButton = SKLabelNode(fontNamed: "Chalkboard SE")
        saveResultButton.text = "Save Result"
        saveResultButton.fontSize = 24
        saveResultButton.fontColor = SKColor.systemPink
        saveResultButton.name = "saveResultButton"
        saveResultButton.position = CGPoint(x: 0, y: 20)
        background.addChild(saveResultButton)

        let closeButton = SKLabelNode(fontNamed: "Chalkboard SE")
        closeButton.text = "Close"
        closeButton.fontSize = 24
        closeButton.fontColor = SKColor.cyan
        closeButton.name = "closeButton"
        closeButton.position = CGPoint(x: 0, y: -60)
        background.addChild(closeButton)
    }

    
    func appearAnimation() {
        self.alpha = 0
        self.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let nodesAtPoint = self.nodes(at: location)
        for node in nodesAtPoint {
            switch node.name {
            case "closeButton":
                self.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.3),
                    SKAction.removeFromParent()
                ]))
            case "saveResultButton":
                presentResultsViewController()
            default:
                break
            }
        }
    }
    
    func presentResultsViewController() {
        guard let scene = self.scene as? SKScene, let viewController = scene.view?.window?.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController {
            resultsVC.modalPresentationStyle = .fullScreen
            viewController.present(resultsVC, animated: true, completion: nil)
        }
    }


}

