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

class DashEndingState: GKState, PlatformLandingDelegate {
    
    unowned var entity: Player
    
    var elapsedTime: TimeInterval = 0.0
    
    var markedPlatform: SKNode?
    
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
                
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            if (entity.component(ofType: MovementComponent.self)?.dashCount)! < GameplayConfiguration.Player.maxDashes {
                let dashCount = self.entity.component(ofType: MovementComponent.self)?.dashCount
                if dashCount! < GameplayConfiguration.Player.maxDashes {
                    let flashCount = 5
                    let flashOut = SKAction.fadeOut(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
                    let flashIn = SKAction.fadeIn(withDuration: GameplayConfiguration.Player.dashEndDuration / Double(flashCount) / 2)
                    let checkDeathAction = SKAction.run({self.checkDeath()})
                    let temporarySequence = SKAction.sequence([flashOut, flashIn, flashOut, flashIn, checkDeathAction])
                    spriteComponent.node.run(temporarySequence)
                } else {
                    checkDeath()
                }
            }
        }
        
        elapsedTime = 0.0
    }
    
    func checkDeath() {
        print("testing death", entity.isOnPlatform)
        if entity.isOnPlatform {
            
            stateMachine?.enter(LandedState.self)
        } else {
            stateMachine?.enter(DeathState.self)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        elapsedTime += seconds
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    func markForLanding(platform: SKNode) {
        markedPlatform = platform
    }
}
