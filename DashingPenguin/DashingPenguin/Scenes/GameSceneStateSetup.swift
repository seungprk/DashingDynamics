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
        
        // Initialize touch input node
        let controlInputNode = TouchControlInputNode(frame: scene.frame)
        controlInputNode.delegate = scene
        
        // Camera Node Setup
        scene.cameraNode = SKCameraNode()
        scene.cameraNode?.addChild(controlInputNode)
        controlInputNode.position = scene.cameraNode!.position
        scene.addChild(scene.cameraNode!)
        scene.camera = scene.cameraNode

        // Player Entity Setup
        scene.player = Player(imageNamed: "penguin-front")
        scene.platformLandingDelegate = scene.player!.landedState
        scene.entities.append(scene.player!)
        if let playerSprite = scene.player?.component(ofType: SpriteComponent.self) {
            scene.addChild(playerSprite.node)
        }
        
        if let overlay = SKNode.unarchiveFromFile(file: "Overlay")?.childNode(withName: "Overlay"),
            let playerSprite = scene.player?.component(ofType: SpriteComponent.self)?.node {
            overlay.removeFromParent()
            overlay.zPosition = GameplayConfiguration.HeightOf.overlay
            overlay.position = CGPoint(x: 0, y: -playerSprite.position.y - scene.size.height * 0.3)
            scene.camera?.addChild(overlay)
        }
        
        // Physics
        scene.setupPhysics()
        scene.zoneManager = ZoneManager(scene: scene)
        scene.laserIdDelegate = scene.zoneManager
        
        scene.player?.component(ofType: MovementComponent.self)?.enterInitialState()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
}
