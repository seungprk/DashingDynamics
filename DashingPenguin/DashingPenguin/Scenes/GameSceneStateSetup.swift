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
        
        // Add Background, Hud and Score Managers
        scene.bgManager = BackgroundManager(scene: scene)
        scene.hudManager = HudManager(scene: scene)
        scene.scoreManager = ScoreManager(scene: scene)
        
        // Add Side wall physics to camera node
        let rightWallCenter = CGPoint(x: scene.size.width / 2 - GameplayConfiguration.Sidewall.width / 2, y: 0)
        let leftWallCenter = CGPoint(x: -scene.size.width / 2 + GameplayConfiguration.Sidewall.width / 2, y: 0)
        
        let wallRight = SKPhysicsBody(rectangleOf: CGSize(width: GameplayConfiguration.Sidewall.width, height: scene.size.height * 2), center: rightWallCenter)
        let wallLeft = SKPhysicsBody(rectangleOf: CGSize(width: GameplayConfiguration.Sidewall.width, height: scene.size.height * 2), center: leftWallCenter)
        wallLeft.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        wallRight.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        wallLeft.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        wallRight.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        wallLeft.isDynamic = false
        wallRight.isDynamic = false
        
        let wallRightNode = SKNode()
        let wallLeftNode = SKNode()
        wallRightNode.physicsBody = wallRight
        wallLeftNode.physicsBody = wallLeft
        scene.cameraNode?.addChild(wallRightNode)
        scene.cameraNode?.addChild(wallLeftNode)
        
        // Add Side wall
        scene.sideWall = ObstacleSideWall(size: scene.size)
        
        // Player Entity Setup
        scene.player = Player()
        scene.platformLandingDelegate = scene.player!.landedState
        scene.wallContactDelegate = scene.player!.dashingState
        print("PLAYER DELEGATES: \n\(scene.player!.landedState) \(scene.player!.dashingState)")
        
        scene.entities.append(scene.player!)
        if let playerSprite = scene.player?.component(ofType: SpriteComponent.self) {
            playerSprite.node.position = CGPoint(x: 0, y: GameplayConfiguration.Platform.size.height/2)
            scene.addChild(playerSprite.node)
        }
        
        let pauseButton = SKButton(size: CGSize(width: 40, height: 40), nameForImageNormal: "pause_on", nameForImageNormalHighlight: "pause_off")
        pauseButton.name = "pauseButton"
        pauseButton.delegate = scene
        pauseButton.zPosition = GameplayConfiguration.HeightOf.overlay + GameplayConfiguration.HeightOf.controlInputNode
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: scene.frame.midX - pauseButton.frame.width * 0.5, y: scene.frame.midY - pauseButton.frame.height * 0.5)
        //scene.camera?.addChild(pauseButton)
        
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
