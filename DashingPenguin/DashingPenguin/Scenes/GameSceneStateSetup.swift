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
        
        // Camera Node Setup
        scene.cameraNode = SKCameraNode()
        scene.addChild(scene.cameraNode!)
        scene.camera = scene.cameraNode
        
        // Setup Screen Effect Node
        let filter = CIFilter(name: "CIPixellate")
        filter?.setDefaults()
        filter?.setValue(10.0, forKey: "inputScale")
        
        scene.sceneEffectNode = SKEffectNode()
        scene.sceneEffectNode.shouldCenterFilter = true
        scene.sceneEffectNode.shouldEnableEffects = false
        scene.sceneEffectNode.filter = filter
        scene.addChild(scene.sceneEffectNode)
        
        scene.sceneCamEffectNode = SKEffectNode()
        scene.sceneCamEffectNode.shouldCenterFilter = true
        scene.sceneCamEffectNode.shouldEnableEffects = false
        scene.sceneCamEffectNode.filter = filter
        scene.camera?.addChild(scene.sceneCamEffectNode)
        
        // Initialize touch input node
        let controlInputNode = TouchControlInputNode(frame: scene.frame)
        controlInputNode.delegate = scene
        scene.sceneCamEffectNode.addChild(controlInputNode)
        
        // Player Entity Setup
        scene.player = Player()
        scene.platformLandingDelegate = scene.player!.landedState
        scene.wallContactDelegate = scene.player!.dashingState
//        print("PLAYER DELEGATES: \n\(scene.player!.landedState) \(scene.player!.dashingState)")
        
        scene.entities.append(scene.player!)
        if let playerSprite = scene.player?.component(ofType: SpriteComponent.self) {
            scene.sceneEffectNode.addChild(playerSprite.node)
        }
        
        // Add Background, Hud and Score Managers
        scene.bgManager = BackgroundManager(scene: scene)
        scene.hudManager = HudManager(scene: scene)
        scene.scoreManager = ScoreManager(scene: scene)
        scene.creepDeathManager = CreepDeathManager(scene: scene)
        scene.hudManager.hudNode.zPosition = controlInputNode.zPosition + 100 // needs to be on top of touch control input
        
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
        wallRightNode.name = "wallRightNode"
        let wallLeftNode = SKNode()
        wallRightNode.name = "wallLeftNode"
        wallRightNode.physicsBody = wallRight
        wallLeftNode.physicsBody = wallLeft
        scene.sceneCamEffectNode.addChild(wallRightNode)
        scene.sceneCamEffectNode.addChild(wallLeftNode)
        
        // Add Side wall
        scene.sideWall = ObstacleSideWall(scene: scene)
        
        // Add Pause Button
        let pauseButton = SKButton(size: CGSize(width: 40, height: 40), nameForImageNormal: "pause_on", nameForImageNormalHighlight: "pause_off")
        pauseButton.name = "pauseButton"
        pauseButton.delegate = scene
        pauseButton.zPosition = GameplayConfiguration.HeightOf.overlay + GameplayConfiguration.HeightOf.controlInputNode
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: scene.frame.midX - pauseButton.frame.width * 0.5, y: scene.frame.midY - pauseButton.frame.height * 0.5)
        //scene.camera?.addChild(pauseButton)
        
        // Physics
        scene.setupPhysics()
        scene.zoneManager = ZoneManager(scene: scene)
        
        // Camera and background positioning
        scene.cameraNode?.position = CGPoint(x: 0, y: scene.size.height * 0.3 + GameplayConfiguration.Platform.size.height / 2)
        scene.bgManager.bgNode.position = CGPoint(x: 0, y: (-scene.size.height * 0.3 - GameplayConfiguration.Platform.size.height / 2) * scene.bgManager.parallaxFactor)
        
        // Setup Magnet
        let magnetVector = vector_float3(1,0,0)
        scene.magnetNode = SKFieldNode.linearGravityField(withVector: magnetVector)
        scene.magnetNode.categoryBitMask = GameplayConfiguration.PhysicsBitmask.field
        scene.magnetNode.falloff = 0
        scene.magnetNode.strength = 2
        scene.magnetNode.isEnabled = false
        scene.addChild(scene.magnetNode)
        
        scene.player?.component(ofType: MovementComponent.self)?.enterInitialState()
        self.stateMachine?.enter(GameSceneStateIntro.self)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStateIntro.Type
    }
}
