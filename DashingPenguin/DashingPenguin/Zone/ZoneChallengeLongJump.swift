//
//  ZoneChallengeFewPlatforms.swift
//  DashingPenguin
//
//  Created by Seung Park on 10/2/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneChallengeLongJump: Zone {
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
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
            })
            
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            
            // Deactivate Challenge
            let removeNode = scene.cameraNode?.childNode(withName: "challengeOverlayNode")
            removeNode?.removeFromParent()
            
            // Run Exit Animation
            
            print("EXIT ZONE!!")
            hasBeenExited = true
        }
    }
    
}
