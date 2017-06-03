//
//  ScoreManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 1/25/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ScoreManager {
    var scene: GameScene!
    var distanceScore: CGFloat = 0
    var platformScore: CGFloat = 0
    var highScore: CGFloat = 0
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Get saved high score
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.object(forKey: "highScore") {
            highScore = value as! CGFloat
        }
    }
    
    func updateDistanceScore() {
        let playerYPos = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let distFactor = playerYPos! / 30
        if distFactor > distanceScore {
            distanceScore = distFactor
            scene.hudManager.updateScoreNumber(to: getTotalScore())
        }
        
        checkHighScore()
    }
    
    func incrementPlatformPart() {
        platformScore += 10
        scene.hudManager.updateScoreNumber(to: getTotalScore())
        scene.hudManager.popAnimateScore()
        
        checkHighScore()
    }
    
    func checkHighScore() {
        if (distanceScore + platformScore) > highScore {
            highScore = distanceScore + platformScore
        }
    }
    
    func saveHighScore() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highScore")
    }
    
    // These may be changed safely in the future to provide better 
    // score results

    func getTotalScore() -> Int {
        return Int(distanceScore + platformScore)
    }
    
    func getDistanceScore() -> Int {
        return Int(distanceScore)
    }
    
    func getPlatformScore() -> Int {
        return Int(platformScore)
    }
    
    func getHighScore() -> Int {
        return Int(highScore)
    }
}
