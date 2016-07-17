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

    private var lastUpdateTime: TimeInterval = 0
    var penguinAtlas = SKTextureAtlas(named: "Penguin")
    var controlInputNode: TouchControlInputNode?
    var cameraNode: SKCameraNode?
    var tempPlayer = Player(imageNamed: "penguin-front")
    var platformBlocksManager: PlatformBlocksManager!
    
    // MARK: - Scene Setup
    
    override func sceneDidLoad() {
        
        // Misc Setup
        backgroundColor = SKColor.white()
        self.lastUpdateTime = 0
        
        // Label for testing
        let label = SKLabelNode(text: "Dashing Penguin")
        label.fontColor = UIColor.black()
        label.alpha = 1.0
        label.run(SKAction.fadeIn(withDuration: 2.0))
        addChild(label)
        
        // Initialize touch input node
        let controlInputNode = TouchControlInputNode(frame: self.frame)
        controlInputNode.delegate = self
        
        // Camera Node Setup
        cameraNode = SKCameraNode()
        cameraNode?.addChild(controlInputNode)
        controlInputNode.position = cameraNode!.position
        addChild(cameraNode!)
        camera = cameraNode
        
        // Temp Player Entity Setup
        if let playerSprite = tempPlayer.componentForClass(SpriteComponent.self)?.node {
            playerSprite.size = CGSize(width: 40, height: 50)
        }
        addChild((tempPlayer.componentForClass(SpriteComponent.self)?.node)!)
        
        // Platform Manager Setup
        platformBlocksManager = PlatformBlocksManager(scene: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        platformBlocksManager.checkIfBlockNeedsToBeAdded()
        platformBlocksManager.checkIfBlockNeedsToBeRemoved()
        updateCurrentTime(currentTime)
        centerCamera()
    }
    
    func updateCurrentTime(_ currentTime: TimeInterval) {
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
    
    func swipeGesture(velocity: CGVector) {
        if let playerSprite = tempPlayer.componentForClass(SpriteComponent.self)?.node {
            playerSprite.run(SKAction.move(by: velocity, duration: 0.1))
        }
    }
    
    func tapGesture(at location: CGPoint) {
        print("tapGesture(at:) has not been implemented")
    }
    
    func centerCamera() {
        if let playerSprite = tempPlayer.componentForClass(SpriteComponent.self)?.node {
            let move = SKAction.move(to: CGPoint(x: 0, y: playerSprite.position.y), duration: 0.2)
            move.timingMode = .easeOut
            cameraNode?.run(move)
        }
    }
}
