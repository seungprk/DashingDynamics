//
//  ZoneA.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneNormal: Zone {
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.addBlock(withType: "ObstacleLaser")
        platformBlocksManager.addBlock(withType: "ObstacleLaser")
        platformBlocksManager.addBlock(withType: "ObstacleLaser")
        platformBlocksManager.addBlock(withType: "ObstacleLaser")
//        platformBlocksManager.generateRandomBlocks(amount: 3)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
    }
    
}
