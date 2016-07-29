//
//  Zone.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Zone {
    
    var platformBlocksManager: PlatformBlocksManager!
    
    init(scene: GameScene) {
        platformBlocksManager = PlatformBlocksManager(scene: scene)
    }
    
}
