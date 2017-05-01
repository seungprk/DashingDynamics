//
//  DashingState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DashingState: GKState, WallContactDelegate {
    
    unowned var entity: Player
    
    var elapsedTime: TimeInterval = 0.0
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Remove DashEndingState's visual effects
        entity.component(ofType: MovementComponent.self)?.dashCount += 1
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.removeAction(forKey: "flashingSequence")
            spriteComponent.node.alpha = 1
        }
        
        // Reset elapsed time
        elapsedTime = 0.0
        
        // Give initial impulse to the player
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self),
            let dashVelocity = self.entity.component(ofType: MovementComponent.self)?.dashVelocity {
            spriteComponent.node.physicsBody?.applyImpulse(dashVelocity)
        }
        
        AudioManager.sharedInstance.play("energy-burst")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        elapsedTime += seconds

        // When dashing duration is up,
        // Stop the player and enter DashEndingState
        if elapsedTime > GameplayConfiguration.Player.dashDuration {
            if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
                spriteComponent.node.physicsBody?.velocity = CGVector.zero
            }
            self.stateMachine?.enter(DashEndingState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DashEndingState.Type, is LandedState.Type, is DeathState.Type:
            return true
        default:
            return false
        }
    }
    
    func didContactWall() {
        print("HITWALL")
    }
}
