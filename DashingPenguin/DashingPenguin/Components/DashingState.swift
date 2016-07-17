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
    
    override func didEnter(withPreviousState previousState: GKState?) {
        super.didEnter(withPreviousState: previousState)
        
        entity.componentForClass(MovementComponent.self)?.dashCount += 1
        
        elapsedTime = 0.0

        if let velocity = self.entity.componentForClass(MovementComponent.self)?.velocity,
               spriteComponent = self.entity.componentForClass(SpriteComponent.self) {
            spriteComponent.node.run(SKAction.move(by: velocity, duration: GameplayConfiguration.Player.dashDuration), completion: {
                
                self.stateMachine?.enterState(DashEndingState.self)
            })
        }

    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        super.update(withDeltaTime: seconds)
        
        elapsedTime += seconds
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is DashEndingState.Type
    }
}
