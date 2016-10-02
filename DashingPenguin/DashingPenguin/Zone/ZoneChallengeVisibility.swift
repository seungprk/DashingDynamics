//
//  ZoneB.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneChallengeVisibility: Zone {
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.generateRandomBlocks(amount: 1)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.platforms.first
        firstPlatform.component(ofType: SpriteComponent.self)?.node.color = UIColor.darkGray
    }
    
    override func enterEvent() {
        if hasBeenEntered == false {
            print("challenge zone entered")
            hasBeenEntered = true
            scene.stateMachine.enter(GameSceneStateCinematicPause.self)
            
            // Setup Challenge Start Overlay
            let challengeOverlayNode = SKNode()
            challengeOverlayNode.name = "challengeOverlayNode"
            
            let flashingLabel = SKLabelNode(text: "CHALLENGE!!")
            flashingLabel.name = "flashingLabel"
            flashingLabel.fontColor = UIColor.black
            flashingLabel.position = CGPoint(x: 0, y: 0)
            
            scene.cameraNode?.addChild(challengeOverlayNode)
            challengeOverlayNode.addChild(flashingLabel)
            
            // Animate Layer
            let flashingAction = SKAction.sequence([SKAction.fadeIn(withDuration: 1), SKAction.fadeOut(withDuration: 1)])
            
            flashingLabel.run(flashingAction, completion: {
                self.scene.cameraNode?.childNode(withName: "flashingLabel")?.removeFromParent()
                self.scene.stateMachine.enter(GameSceneStatePlaying.self)
                
                // Setup Challenge Activation
                let blinderOverlayNode = SKSpriteNode(texture: nil, color: UIColor.blue, size: self.scene.size)
                blinderOverlayNode.name = "blinderOverlayNode"
                blinderOverlayNode.position = CGPoint.zero
                blinderOverlayNode.zPosition = GameplayConfiguration.HeightOf.overlay
                let blinderAction = SKAction.sequence([SKAction.fadeIn(withDuration: 0.1), SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.1), SKAction.wait(forDuration: 2)])
                let blinderRepeatAction = SKAction.repeatForever(blinderAction)
                
                // Activate Challenge
                challengeOverlayNode.addChild(blinderOverlayNode)
                blinderOverlayNode.run(blinderRepeatAction)
            })

        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            
            // Deactivate Challenge
            let removeNode = scene.cameraNode?.childNode(withName: "challengeOverlayNode")
            removeNode?.removeFromParent()
            scene.player?.removeComponent(ofType: MagnetMoveComponent.self)
            
            // Run Exit Animation
            
            print("EXIT ZONE!!")
            hasBeenExited = true
        }
    }
    
}
