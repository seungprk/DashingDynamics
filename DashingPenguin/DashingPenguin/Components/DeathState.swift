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
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        print("DEAD")
        let spriteComponent = self.entity.component(ofType: SpriteComponent.self)
        spriteComponent?.node.removeAllActions()
        spriteComponent?.node.physicsBody?.velocity = CGVector.zero
        entity.component(ofType: SpriteComponent.self)?.node.alpha = 0.1
        entity.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity = CGVector.zero
    }
}
