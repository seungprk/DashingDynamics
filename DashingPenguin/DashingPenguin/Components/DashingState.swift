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
            spriteComponent.node.physicsBody?.velocity.dx += dashVelocity.dx
            spriteComponent.node.physicsBody?.velocity.dy += dashVelocity.dy
        }
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

        // Slow down the player based on its current velocity
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self),
            let currentVelocity = spriteComponent.node.physicsBody?.velocity {
            
            // ** Other Possible Formulas **
            // https://www.desmos.com/calculator/j16otdoh4a
            // initialRate = ~0.0
            // finalRate   = ~0.2
            // FORMULA1: y = 20 ^ (x - 1.5)
            // FORMULA2: y = 200 ^ (x - 1.3)
            // FORMULA3: y = 20000 ^ (x - 1.1)
            // FORMULA4: y = 20000 ^ (x - 0.4)
            // FORMULAcurrent: y = 20000 ^ (x - 0.55)
            
            // Calculate percentage of elapsed time
            var progress = CGFloat(elapsedTime / GameplayConfiguration.Player.dashDuration)
            if (progress > 1) { progress = 1 }
            
            var rate: CGFloat = pow(20000, (progress - GameplayConfiguration.Player.dashMagnitude))
            if (rate < 0) { rate = 0 }
            if (rate > 0.2) { rate = 0.2 }
            
            let relativeVelocity = CGVector(dx: 0 - currentVelocity.dx, dy: 0 - currentVelocity.dy)
            let updatedVelocity = CGVector(dx: currentVelocity.dx + relativeVelocity.dx * rate,
                                           dy: currentVelocity.dy + relativeVelocity.dy * rate)
            
            spriteComponent.node.physicsBody?.velocity = updatedVelocity
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
    
//    func curvedProgress(elapsed: TimeInterval) -> Double {
//        let dashCompletion = min(1, elapsed / GameplayConfiguration.Player.dashDuration)
//        return -(pow(-dashCompletion, 10) - 1)
//    }
    
    func didContactWall() {
        print("HITWALL")
    }
}
