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
    
    init(imageNamed imageName: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = GameplayConfiguration.Player.size
        
        let physicsBody = SKPhysicsBody(circleOfRadius: GameplayConfiguration.Player.physicsBodyRadius, center: CGPoint.zero)
        physicsBody.collisionBitMask   = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.platform
        
        addComponent(spriteComponent)
        addComponent(MovementComponent(states: [ LandedState(entity: self),
                                                 DashingState(entity: self),
                                                 DashEndingState(entity: self),
                                                 DeathState(entity: self) ]))
        
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        componentForClass(MovementComponent.self)?.update(withDeltaTime: seconds)
    }
    
}
