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

    var controlInputNode: TouchControlInputNode?
    var cameraNode: SKCameraNode?
    var player: Player?
    var platformBlocksManager: PlatformBlocksManager!
    var zoneManager: ZoneManager!
    
    private var lastUpdateTime: TimeInterval = 0
    internal var physicsContactCount = 0
    var platformLandingDelegate: PlatformLandingDelegate?
    
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
        
        // Player Entity Setup
        self.player = Player(imageNamed: "penguin-front")
        platformLandingDelegate = self.player!.playerDashEndingState
        entities.append(player!)
        if let playerSprite = player?.componentForClass(SpriteComponent.self) {
            addChild(playerSprite.node)
        }
        
        // Physics
        setupPhysics()
        zoneManager = ZoneManager(scene: self)
    }
    
    override func didMove(to view: SKView) {
        player?.componentForClass(MovementComponent.self)?.enterInitialState()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateCurrentTime(currentTime)
        centerCamera()
    }
    
    func updateCurrentTime(_ currentTime: TimeInterval) {
        // Initialize lastUpdateTime if it has not already been
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
        if let playerMovement = player?.componentForClass(MovementComponent.self) {
            playerMovement.dash(velocity)
        }
    }
    
    func tapGesture(at location: CGPoint) {
        print("tapGesture(at:) has not been implemented")
    }
    
    func centerCamera() {
        if let playerSprite = player?.componentForClass(SpriteComponent.self)?.node {
            let move = SKAction.move(to: CGPoint(x: 0, y: playerSprite.position.y + self.size.height * 0.3), duration: 0.2)
            move.timingMode = .easeOut
            cameraNode?.run(move)
        }
    }
    
}
