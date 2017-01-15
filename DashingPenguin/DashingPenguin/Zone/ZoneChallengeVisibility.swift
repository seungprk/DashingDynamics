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
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat, begZPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos, begZPos: begZPos)
        platformBlocksManager.generateRandomBlocks(amount: 3)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
    }
    
    override func enterEvent() {
        super.enterEvent()
        
        if hasBeenEntered == false {
            hasBeenEntered = true
            
            // Setup Challenge Activation
            let blinderOverlayNode = SKSpriteNode(texture: nil, color: UIColor.blue, size: self.scene.size)
            blinderOverlayNode.name = "blinderOverlayNode"
            blinderOverlayNode.position = CGPoint.zero
            blinderOverlayNode.zPosition = GameplayConfiguration.HeightOf.overlay
            let blinderAction = SKAction.sequence([SKAction.fadeIn(withDuration: 0.1), SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.1), SKAction.wait(forDuration: 2)])
            let blinderRepeatAction = SKAction.repeatForever(blinderAction)
            
            // Activate Challenge
            scene.cameraNode?.childNode(withName: "challengeOverlayNode")?.addChild(blinderOverlayNode)
            blinderOverlayNode.run(blinderRepeatAction)
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            super.exitEvent()
            hasBeenExited = true
        }
    }
    
}
