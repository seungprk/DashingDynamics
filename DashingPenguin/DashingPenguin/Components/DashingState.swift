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
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.removeAction(forKey: "flashingSequence")
            spriteComponent.node.alpha = 1
        }
        
        elapsedTime = 0.0

//        if let dashVelocity    = self.entity.component(ofType: MovementComponent.self)?.dashVelocity,
//           let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
//            let velocityMod: CGFloat = 10
//            let modVelocity = CGVector(dx: dashVelocity.dx*velocityMod, dy: dashVelocity.dy*velocityMod)
//            let origVelocity = (spriteComponent.node.physicsBody?.velocity)!
//            let sumVelocity = CGVector(dx: origVelocity.dx+modVelocity.dx, dy: origVelocity.dy+modVelocity.dy)
//            spriteComponent.node.physicsBody?.applyImpulse(sumVelocity)
//            
//            print("CURRENT STATE: ", stateMachine?.currentState)
//            print("applied VEL", sumVelocity)
//            print("VEL after applied", spriteComponent.node.physicsBody?.velocity)
//            
//            spriteComponent.node.run(SKAction.wait(forDuration: GameplayConfiguration.Player.dashDuration), completion: {
//                spriteComponent.node.physicsBody?.velocity = CGVector.zero
//                if let magnetComponent = self.entity.component(ofType: MagnetMoveComponent.self) {
//                    spriteComponent.node.physicsBody?.velocity = CGVector(dx: magnetComponent.velocityX, dy: 0)
//                }
//                print((spriteComponent.node.physicsBody?.velocity)!)
//                self.stateMachine?.enter(DashEndingState.self)
//            })
//        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        elapsedTime += seconds
        
        let rate = CGFloat(50 * elapsedTime)
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: rate))
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
}
