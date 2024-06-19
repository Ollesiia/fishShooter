//
//  Constants.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import Foundation
import UIKit

struct K {
    
    struct WebView {
        static let webViewRegistrationURL: String = "https://quiz-appservice.bleksi.com/quiz-auth"
        static let failedMessage: String = "Failed to process URL"
        static let userIDKey = "userID"
        static let fullrefKey = "fullref"
    }
    
    struct Levels {
        static let lightLevelGridSize: Int = 3
        static let mediumLevelGridSize: Int = 4
        static let highLevelGridSize: Int = 5
    }
    
    struct Game {
        static let initialGridSize = 3
        static let buttonFontSize: CGFloat = 24
        static let buttonBorderWidth: CGFloat = 0.5
        static let buttonBorderColor = UIColor.black.cgColor
        static let buttonTitleColor = UIColor.black
        static let gridSpacing: CGFloat = 10
        static let gridWidthMultiplier: CGFloat = 0.9
    }
    
    struct Messages {
        static let incorrect: String = "Incorrect URL"
        static let error: String = "Error"
        static let ok: String = "OK"
        static let pageLoadError: String = "Page load error"
        static let startAgain: String = "Start again"
        static let recordTheResult: String = "Record the result"
        static let earnedPoints = "Points earned"
        static let gameOver: String = "Game over!"
        static let yourTime: String = "Your time"
    }
}

