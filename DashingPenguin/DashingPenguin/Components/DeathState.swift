//
//  DeathState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DeathState: GKState {
    
    unowned var entity: Player
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LandedState.Type
    }
}
