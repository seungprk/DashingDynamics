//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Platform: GKEntity {
    
    let size = CGSize(width: 50, height: 50)
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(color: UIColor.green, size: self.size)
        let physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size, center: spriteComponent.node.position)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.isDynamic = true
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    /**
     * Initializer for a moving platform.
     */
    init(scene: SKScene, slidingMagnitude: CGFloat, yPosition: CGFloat) {
        super.init()
        
        let possibleCenterMin = size.width / 2 + slidingMagnitude / 2 - scene.frame.width / 2
        let possibleCenterMax = scene.frame.width - size.width / 2 - slidingMagnitude / 2 - scene.frame.width / 2
        let randomSlidingCenterX = CGFloat(arc4random_uniform(UInt32(possibleCenterMax - possibleCenterMin))) + possibleCenterMin
        print("\(randomSlidingCenterX) in \(scene.frame.width) between \(possibleCenterMin) and \(possibleCenterMax)")
        
        let spriteComponent = SpriteComponent(color: UIColor.green, size: self.size)
        let physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size, center: spriteComponent.node.position)
        
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.isDynamic = true
        spriteComponent.node.physicsBody = physicsBody
        spriteComponent.node.position = CGPoint(x: randomSlidingCenterX, y: yPosition) // spriteComponent.node.position.y)
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
        
        let slidingComponent = SlidingComponent(node: spriteComponent.node,
                                                centerX: randomSlidingCenterX,
                                                magnitude: slidingMagnitude)
        addComponent(slidingComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
