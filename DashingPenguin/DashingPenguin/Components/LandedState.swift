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
    }
    
    override func update(deltaTime seconds: TimeInterval) {

        if let previousPlatformPosition = previousPlatformPosition {
            
            let deltaX = currentPlatform!.position.x - previousPlatformPosition.x
            let deltaY = currentPlatform!.position.y - previousPlatformPosition.y
            
            entity.component(ofType: SpriteComponent.self)?.node.position.x += deltaX
            entity.component(ofType: SpriteComponent.self)?.node.position.y += deltaY

//            let delay = SKAction.wait(forDuration: 0.05)
//            let move = SKAction.move(by: CGVector(dx: deltaX, dy: deltaY), duration: 0.4)
//            move.timingMode = .easeIn
//            entity.component(ofType: SpriteComponent.self)?.node.run(SKAction.sequence([delay, move]))
        }
        
        if let currentPlatform = currentPlatform {
            previousPlatformPosition = currentPlatform.position
        }

    }
    
    override func willExit(to nextState: GKState) {
        currentPlatform = nil
        previousPlatformPosition = nil
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DashingState.Type:
            return true
        default:
            return false
        }
    }
    
    func markForLanding(platform: SKNode) {
        currentPlatform = platform
    }

}
