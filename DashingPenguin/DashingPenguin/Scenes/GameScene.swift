//
//  GameScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/3/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    
    // Game Logic
    private var lastUpdateTime: TimeInterval = 0
    
    // Assets
    var penguinAtlas = SKTextureAtlas(named: "Penguin")
    
    // MARK: - Scene Setup
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        let label = SKLabelNode(text: "DashingDuo")
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.alpha = 0.0
        label.run(SKAction.fadeIn(withDuration: 2.0))
        addChild(label)
    }
 
    // MARK: - Touch overrides
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(withDeltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
