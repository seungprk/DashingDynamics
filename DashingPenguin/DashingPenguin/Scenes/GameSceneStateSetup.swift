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
        scene.backgroundColor = SKColor.black
        scene.lastUpdateTime = 0
        
        // Initialize touch input node
        let controlInputNode = TouchControlInputNode(frame: scene.frame)
        controlInputNode.delegate = scene
        
        // Camera Node Setup
        scene.cameraNode = SKCameraNode()
        scene.cameraNode?.addChild(controlInputNode)
        controlInputNode.position = scene.cameraNode!.position
        scene.addChild(scene.cameraNode!)
        scene.camera = scene.cameraNode
        
        // Add walls to camera node
        let rightWallCenter = CGPoint(x: scene.size.width / 2, y: 0)
        let leftWallCenter = CGPoint(x: -scene.size.width / 2, y: 0)
        
        let wallRight = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: scene.size.height * 2), center: rightWallCenter)
        let wallLeft = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: scene.size.height * 2), center: leftWallCenter)
        wallLeft.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        wallRight.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        wallLeft.isDynamic = false
        wallRight.isDynamic = false
        
        let wallRightNode = SKNode()
        let wallLeftNode = SKNode()
        wallRightNode.physicsBody = wallRight
        wallLeftNode.physicsBody = wallLeft
        scene.cameraNode?.addChild(wallRightNode)
        scene.cameraNode?.addChild(wallLeftNode)

        // Player Texture Setup
        let playerAnimatedAtlas = SKTextureAtlas(named: "player")
        var playerTextureFrames = [SKTexture]()
        for i in 1...playerAnimatedAtlas.textureNames.count {
            let textureName = "player\(i)"
            playerTextureFrames.append(playerAnimatedAtlas.textureNamed(textureName))
        }
        
        // Player Entity Setup
        scene.player = Player(textureFrames: playerTextureFrames)
        scene.platformLandingDelegate = scene.player!.landedState
        scene.entities.append(scene.player!)
        if let playerSprite = scene.player?.component(ofType: SpriteComponent.self) {
            scene.addChild(playerSprite.node)
        }
        
        let pauseButton = SKButton(size: CGSize(width: 40, height: 40), nameForImageNormal: "pause_on", nameForImageNormalHighlight: "pause_off")
        pauseButton.name = "pauseButton"
        pauseButton.delegate = scene
        pauseButton.zPosition = GameplayConfiguration.HeightOf.overlay + GameplayConfiguration.HeightOf.controlInputNode
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: scene.frame.midX - pauseButton.frame.width * 0.5, y: scene.frame.midY - pauseButton.frame.height * 0.5)
        scene.camera?.addChild(pauseButton)
        
        /** WIP **
        // Set up overlay with sks objects.
        if let overlayScene = SKScene(fileNamed: "Overlay.sks") {
            let overlay = SKNode()
            overlay.position = CGPoint.zero
            overlay.name = "hudOverlay"
            overlay.zPosition = GameplayConfiguration.HeightOf.overlay
            overlay.setScale(0.5)
            
            for child in overlayScene.children {
                child.removeFromParent()
                child.isUserInteractionEnabled = true
                overlay.addChild(child)
            }

            scene.camera?.addChild(overlay)
        }
        */
        
        // Physics
        scene.setupPhysics()
        scene.zoneManager = ZoneManager(scene: scene)
        scene.laserIdDelegate = scene.zoneManager
        
        scene.player?.component(ofType: MovementComponent.self)?.enterInitialState()
        self.stateMachine?.enter(GameSceneStatePlaying.self)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
}
