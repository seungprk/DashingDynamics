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
    var score: CGFloat = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func updateScore() {
        let playerYPos = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let currScore = playerYPos! / 20
        scene.hudManager.updateScoreNumber(to: Int(currScore))
    }
}
