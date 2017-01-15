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
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat, begZPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos, begZPos: begZPos)
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        platformBlocksManager.addBlock(withType: "EnergyMatter")
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
    }
    
    override func enterEvent() {
        super.enterEvent()
        
        if hasBeenEntered == false {
            hasBeenEntered = true
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            super.exitEvent()
            hasBeenExited = true
        }
    }
    
}
