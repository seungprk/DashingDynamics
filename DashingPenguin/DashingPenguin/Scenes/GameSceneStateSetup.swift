//
//  GameSceneStateSetup.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/11/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneStateSetup: GKState {
    
    unowned let scene : GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        // Misc Setup
        scene.backgroundColor = SKColor.white
        scene.lastUpdateTime = 0
        
        // Label for testing
        let label = SKLabelNode(text: "Dashing Penguin")
        label.fontColor = UIColor.black
        label.alpha = 1.0
        label.run(SKAction.fadeIn(withDuration: 2.0))
        label.position = CGPoint(x: 0, y: 300)
        scene.addChild(label)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
}
