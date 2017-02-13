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

    init(scene: GameScene) {
        self.scene = scene
    }
    
    func updateDistanceScore() {
        let playerYPos = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let distFactor = playerYPos! / 30
        if distFactor > distanceScore {
            distanceScore = distFactor
            scene.hudManager.updateScoreNumber(to: getTotalScore())
        }
    }
    
    func incrementPlatformPart() {
        platformScore += 10
        scene.hudManager.updateScoreNumber(to: getTotalScore())
        scene.hudManager.popAnimateScore()
    }
    
    func getTotalScore() -> Int {
        return Int(distanceScore + platformScore)
    }
}
