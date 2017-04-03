//
//  ZoneB.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneChallengeMagnet: Zone {
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.generateRandomBlocks(amount: 3)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
    }
    
    override func enterEvent() {
        super.enterEvent()
        
        if hasBeenEntered == false {
            // Activate Challenge
            self.scene.player?.addComponent(MagnetMoveComponent(velocityX: 30))
            let magnetComponent = self.scene.player?.component(ofType: MagnetMoveComponent.self)
            magnetComponent?.beginMagnetEffect()
            
            hasBeenEntered = true
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            super.exitEvent()
            
            // Deactivate Challenge
            scene.player?.removeComponent(ofType: MagnetMoveComponent.self)
            
            hasBeenExited = true
        }
    }
    
}
