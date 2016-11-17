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
        
        entity.component(ofType: MovementComponent.self)?.dashCount += 1
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.removeAction(forKey: "flashingSequence")
            spriteComponent.node.alpha = 1
        }
        
        elapsedTime = 0.0
        
//        if let dashVelocity = self.entity.component(ofType: MovementComponent.self)?.dashVelocity {
//            let velocityMod: CGFloat = 10
//            let modVelocity = CGVector(dx: dashVelocity.dx*velocityMod, dy: dashVelocity.dy*velocityMod)
//        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        elapsedTime += seconds

        if elapsedTime > GameplayConfiguration.Player.dashDuration {
            if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
                spriteComponent.node.physicsBody?.velocity = CGVector.zero
            }
            self.stateMachine?.enter(DashEndingState.self)
        }
        
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self),
            let dashVelocity = self.entity.component(ofType: MovementComponent.self)?.dashVelocity {
            
            let progress = curvedProgress(elapsed: elapsedTime)
//            let rate = CGFloat(3.4 * progress)
            let rate = CGFloat(5 * progress)
            let currentVelocity = CGVector(dx: dashVelocity.dx * rate, dy: dashVelocity.dy * rate)
            
            spriteComponent.node.physicsBody?.applyImpulse(currentVelocity)
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
    
    func curvedProgress(elapsed: TimeInterval) -> Double {
        let dashCompletion = min(1, elapsed / GameplayConfiguration.Player.dashDuration)
        return -(pow(-dashCompletion, 10) - 1)
    }
    
    func didContactWall() {
        print("HITWALL")
    }
}
