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
    
    override init(scene: GameScene, begYPos: CGFloat) {
        super.init(scene: scene, begYPos: begYPos)
        platformBlocksManager.addBlock(withType: "SingleDash")
        platformBlocksManager.addBlock(withType: "SingleDash")
        initSize()
    }
    
}
