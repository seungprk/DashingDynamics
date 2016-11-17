//
//  Player.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol LaserContactDelegate {
    func laserBodyDidContactPlayer()
}

class Player: GKEntity {
    
    var isOnPlatform = true
    var landedState: LandedState?
    var dashingState: DashingState?
    
    // Single Texture Initialization
    init(imageNamed imageName: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        initPhysics(spriteComponent: spriteComponent)
    }
    
    // Multi Texture Initialization
    init(textureFrames: [SKTexture]) {
        super.init()
        
        let spriteComponent = SpriteComponent(textureFrames: textureFrames)
        initPhysics(spriteComponent: spriteComponent)
    }
    
    func initPhysics(spriteComponent: SpriteComponent) {
        spriteComponent.node.size = GameplayConfiguration.Player.size
        spriteComponent.node.zPosition = 1000
        
        let physicsBody = SKPhysicsBody(circleOfRadius: GameplayConfiguration.Player.physicsBodyRadius, center: GameplayConfiguration.Player.physicsBodyOffset)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.collisionBitMask   = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.platform
        
        physicsBody.friction = 0
        physicsBody.mass = 1
        physicsBody.linearDamping = 0
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.isDynamic = true
        
        spriteComponent.node.physicsBody = physicsBody
        addComponent(spriteComponent)
        
        landedState = LandedState(entity: self)
        dashingState = DashingState(entity: self)
        addComponent(MovementComponent(states: [ landedState!,
                                                 dashingState!,
                                                 DashEndingState(entity: self),
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
