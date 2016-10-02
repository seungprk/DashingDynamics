//
//  EnergyMatter.swift
//  DashingPenguin
//
//  Created by Seung Park on 10/1/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class EnergyMatter: GKEntity {
    
    var size = CGSize(width: 20, height: 20)
    
    override init() {
        super.init()
        let spriteComponent = SpriteComponent(color: UIColor.blue, size: size)
        
        let physicsBody = SKPhysicsBody(edgeLoopFrom: spriteComponent.node.frame)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.energyMatter
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
