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
        platformBlocksManager.generateRandomBlocks(amount: 3)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
    }
    
    override func enterEvent() {
        super.enterEvent()
        
        if hasBeenEntered == false {
            hasBeenEntered = true
            
            // Setup Challenge Activation
            let filterIn = SKAction.run({
                self.scene.sceneEffectNode.shouldEnableEffects = true
                self.scene.sceneCamEffectNode.shouldEnableEffects = true
            })
            let filterOut = SKAction.run({
                self.scene.sceneEffectNode.shouldEnableEffects = false
                self.scene.sceneCamEffectNode.shouldEnableEffects = false
            })
            let filterAction = SKAction.sequence([SKAction.wait(forDuration: 2),
                                                   filterIn,
                                                   SKAction.wait(forDuration: 1),
                                                   filterOut])
            let filterRepeatAction = SKAction.repeatForever(filterAction)
            
            // Activate Challenge
            scene.run(filterRepeatAction, withKey: "filterRepeatAction")
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            super.exitEvent()
            
            scene.removeAction(forKey: "filterRepeatAction")
            scene.sceneEffectNode.shouldEnableEffects = false
            scene.sceneCamEffectNode.shouldEnableEffects = false
            
            hasBeenExited = true
        }
    }
    
}
