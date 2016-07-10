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
    var graphs = [GKGraph]()
    
    // Game Logic
    private var lastUpdateTime: TimeInterval = 0
    
    // Game Session Info
    private var label: SKLabelNode?
    
    // Touch Debug -> Code for this is in GameScene+TouchDebug.swift
    internal var spinnyNode: SKShapeNode?
    
    // Assets
    var penguinAtlas = SKTextureAtlas(named: "Penguin")
    
    // MARK: - Scene Setup
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        let touchNode = TouchControlInputNode(frame: self.frame)
        touchNode.position = CGPoint(x: self.frame.midX, y:  self.frame.midY)
        addChild(touchNode)
    }

    override func didMove(to view: SKView) {
    }
 
    // MARK: - Touch overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
