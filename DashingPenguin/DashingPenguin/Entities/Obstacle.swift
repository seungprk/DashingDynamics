//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Obstacle: GKEntity {
    
    var size: CGSize!
    
    init(size: CGSize) {
        super.init()
        self.size = size
        let spriteComponent = SpriteComponent(color: UIColor.red, size: size)
        
        let physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size, center: spriteComponent.node.position)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.none
        
        physicsBody.mass = 1000
        
        physicsBody.isDynamic = true
        
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
