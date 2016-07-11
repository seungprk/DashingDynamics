//
//  DashingState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DashingState: GKState {
    
    unowned var entity: Player
    
    required init(entity: Player) {
        self.entity = entity
    }
}