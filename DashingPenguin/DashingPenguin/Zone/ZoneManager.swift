//
//  ZoneManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneManager {
    
    var zones = [Zone]()
    
    init(scene: GameScene) {
        zones.append(Zone(scene: scene))
    }
    
    func update() {
        for zone in zones {
            zone.platformBlocksManager.checkIfBlockNeedsToBeAdded()
            zone.platformBlocksManager.checkIfBlockNeedsToBeRemoved()
        }
    }
    
}
