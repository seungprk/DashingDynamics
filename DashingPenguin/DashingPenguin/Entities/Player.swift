//
//  Player.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var isOnPlatform = false
    var playerDashEndingState: DashEndingState?
    
    init(imageNamed imageName: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = GameplayConfiguration.Player.size
        
        let physicsBody = SKPhysicsBody(circleOfRadius: GameplayConfiguration.Player.physicsBodyRadius, center: CGPoint.zero)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.collisionBitMask   = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.platform
        
//        physicsBody.friction = 1
        physicsBody.mass = 0.1
        physicsBody.usesPreciseCollisionDetection = true
        
        physicsBody.isDynamic = true
        
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        
        playerDashEndingState = DashEndingState(entity: self)
        addComponent(MovementComponent(states: [ LandedState(entity: self),
                                                 DashingState(entity: self),
                                                 playerDashEndingState!,
                                                 DeathState(entity: self) ]))
        
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        component(ofType: MovementComponent.self)?.update(deltaTime: seconds)
    }
    
}
