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
    
    var elapsedTime: TimeInterval = 0.0
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        entity.component(ofType: MovementComponent.self)?.dashCount += 1

        elapsedTime = 0.0

        if let velocity        = self.entity.component(ofType: MovementComponent.self)?.velocity,
           let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
        
            spriteComponent.node.physicsBody?.applyImpulse(velocity)
            spriteComponent.node.run(SKAction.wait(forDuration: GameplayConfiguration.Player.dashDuration), completion: {
                
                spriteComponent.node.physicsBody?.velocity = CGVector.zero
                if self.entity.isOnPlatform {
                    self.stateMachine?.enter(LandedState.self)
                } else {
                    self.stateMachine?.enter(DashEndingState.self)
                }
            })
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        elapsedTime += seconds
    }

    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DashEndingState.Type, is LandedState.Type:
            return true
        default:
            return false
        }
    }
}
