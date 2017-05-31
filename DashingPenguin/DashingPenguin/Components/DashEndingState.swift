//
//  DashEndingState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

let bumpUp = SKAction.scale(to: 1.4, duration: 0.1)
let bumpDown = SKAction.scale(to: 1.0, duration: 0.1)
let bump = SKAction.sequence([bumpUp, bumpDown])

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
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        let spriteComponent = self.entity.component(ofType: SpriteComponent.self)!
        if entity.isOnPlatform {
            stateMachine?.enter(LandedState.self)
        } else if (entity.component(ofType: MovementComponent.self)?.dashCount)! < GameplayConfiguration.Player.maxDashes {
            let flashCount = 5
            let flashOut = SKAction.fadeOut(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
            let flashIn = SKAction.fadeIn(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
            let enterDeathAction = SKAction.run({self.stateMachine?.enter(DeathState.self)})
            let flashingSequence = SKAction.sequence([flashOut, flashIn, flashOut, flashIn, enterDeathAction])
            spriteComponent.node.run(flashingSequence, withKey: "flashingSequence")
        } else {
            // Comment this out to enable invincibility
             stateMachine?.enter(DeathState.self)
        }
        
        elapsedTime = 0.0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        elapsedTime += seconds
        
        if entity.isOnPlatform {
            stateMachine?.enter(LandedState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }

}
