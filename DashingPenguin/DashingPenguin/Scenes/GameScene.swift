//
//  GameScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/3/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameInputDelegate {
    
    var entities = [GKEntity]()
    var graphs = [GKGraph]()
    
    // Game Logic
    private var lastUpdateTime: TimeInterval = 0
    
    // Game Session Info
    private var label: SKLabelNode?
    
    // Assets
    var penguinAtlas = SKTextureAtlas(named: "Penguin")
    
    // Control Input
    var controlInputNode: TouchControlInputNode?
    
    // Camera Node
    var cameraNode: SKCameraNode?
    
    // Temporary Player
    var tempPlayer = SKSpriteNode(color: UIColor.green(), size: CGSize(width: 0.2, height: 0.2))
    
    // MARK: - Scene Setup
    
    override func sceneDidLoad() {

        backgroundColor = SKColor.white()
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Initialize touch input node
        let controlInputNode = TouchControlInputNode(frame: self.frame)
        controlInputNode.delegate = self
        
        cameraNode = SKCameraNode()
        cameraNode?.addChild(controlInputNode)
        
        controlInputNode.position = cameraNode!.position
        
        addChild(cameraNode!)
        camera = cameraNode
    }

    override func didMove(to view: SKView) {
        addChild(tempPlayer)
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
        
        centerCamera()
    }
    
    func swipeGesture(velocity: CGVector) {
        tempPlayer.run(SKAction.move(by: velocity, duration: 0.5))
    }
    
    func tapGesture(at location: CGPoint) {
        print("tapGesture(at:) has not been implemented")
    }
    
    func centerCamera() {
        let move = SKAction.move(to: tempPlayer.position, duration: 0.1)
        move.timingMode = .easeOut
        cameraNode?.run(move)
    }
}
