//
//  DeathState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DeathState: GKState {
    
    unowned var entity: Player
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        print("DEAD")
        let spriteComponent = self.entity.component(ofType: SpriteComponent.self)
        spriteComponent?.node.removeAllActions()
        spriteComponent?.node.physicsBody?.velocity = CGVector.zero
        entity.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity = CGVector.zero
        let gameScene = spriteComponent?.node.scene as! GameScene
        gameScene.cameraFollowsPlayer = false
        
        // Falling Animation
        let animationTime: TimeInterval = 0.5
        let downAction = SKAction.moveBy(x: 0, y: -30, duration: animationTime)
        let shrinkAction = SKAction.scale(to: 0.01, duration: animationTime)
        let fallAction = SKAction.group([downAction, shrinkAction])
        spriteComponent?.node.run(fallAction, completion: {
            spriteComponent?.node.removeFromParent()
        })
    }
}
