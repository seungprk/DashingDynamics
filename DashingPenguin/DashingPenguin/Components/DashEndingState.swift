//
//  DashEndingState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DashEndingState: GKState {
    
    unowned var entity: Player
    
    var elapsedTime: TimeInterval = 0.0
    
    let temporarySequence: SKAction = {
        let flashCount = 5
        let flashOut = SKAction.fadeOut(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
        let flashIn = SKAction.fadeIn(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
        return SKAction.repeat(SKAction.sequence([flashOut, flashIn]), count: flashCount)
    }()
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func didEnter(withPreviousState previousState: GKState?) {
        super.didEnter(withPreviousState: previousState)
                
        if let spriteComponent = self.entity.componentForClass(SpriteComponent.self) {
            spriteComponent.node.run(temporarySequence)
        }
        
        elapsedTime = 0.0
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        super.update(withDeltaTime: seconds)
        
        elapsedTime += seconds
        
        if elapsedTime >= GameplayConfiguration.Player.dashEndDuration {
//            stateMachine?.enterState(LandedState.self)
            
            
            print("testing death", entity.isOnPlatform)
            if entity.isOnPlatform {
                stateMachine?.enterState(LandedState.self)
            } else {
                stateMachine?.enterState(DeathState.self)
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LandedState.Type, is DeathState.Type:
            return true
            
        case is DashingState.Type:
            let dashCount = self.entity.componentForClass(MovementComponent.self)?.dashCount
            
            return dashCount < GameplayConfiguration.Player.maxDashes ? true : false
            
        default:
            return false
        }
    }
}
