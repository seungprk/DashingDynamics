//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleSideWall: GKEntity {
    
    var size: CGSize!
    
    init(size: CGSize, texture: SKTexture? = nil) {
        super.init()
        self.size = size
        let spriteComponent: SpriteComponent!
        if texture == nil {
            spriteComponent = SpriteComponent(color: UIColor.red, size: size)
        } else {
            spriteComponent = SpriteComponent(texture: texture!)
        }
        
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.none
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
