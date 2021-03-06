//
//  LandedState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class LandedState: GKState, PlatformLandingDelegate {
    
    unowned var entity: Player
    var currentPlatform: SKNode?
    var previousPlatformPosition: CGPoint?
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        entity.component(ofType: MovementComponent.self)?.dashCount = 0
        
        // Remove player visual effects and prevent death
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.removeAllActions()
            spriteComponent.node.alpha = 1
        }
        
        // Activate Platform
        if let platform = currentPlatform {
            let platEntity = platform.entity as! Platform
            platEntity.landingActivate()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {

        if entity.isOnPlatform == false {
            stateMachine?.enter(DashEndingState.self)
        }
        
        if let previousPlatformPosition = previousPlatformPosition,
           let currentPlatform = currentPlatform {
            let deltaX = currentPlatform.position.x - previousPlatformPosition.x
            let deltaY = currentPlatform.position.y - previousPlatformPosition.y
            entity.component(ofType: SpriteComponent.self)?.node.position.x += deltaX
            entity.component(ofType: SpriteComponent.self)?.node.position.y += deltaY
        }
        
        if let currentPlatform = currentPlatform {
            previousPlatformPosition = currentPlatform.position
        }

    }
    
    override func willExit(to nextState: GKState) {
        previousPlatformPosition = nil
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DashingState.Type, is DashEndingState.Type, is DeathState.Type:
            return true
        default:
            return false
        }
    }
    
    func markForLanding(platform: SKNode) {
        currentPlatform = platform
    }
    
    func didExitPlatform() {
        currentPlatform = nil
    }

}
