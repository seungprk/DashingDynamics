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
    
    let size = CGSize(width: 100, height: 100)
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(color: UIColor.red(), size: self.size)
        
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
