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
    
    let size = CGSize(width: 29, height: 22)
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "platform1"))
        let physicsPosition = CGPoint(x: spriteComponent.node.position.x, y: spriteComponent.node.position.y + spriteComponent.node.size.height / 2 - size.height / 2 - 1)
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: physicsPosition)
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
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "platform1"))
        let physicsPosition = CGPoint(x: spriteComponent.node.position.x, y: spriteComponent.node.position.y + spriteComponent.node.size.height / 2 - size.height / 2 - 1)
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: physicsPosition)
        
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.isDynamic = true
        spriteComponent.node.physicsBody = physicsBody
        spriteComponent.node.position = CGPoint(x: randomSlidingCenterX, y: yPosition)
        
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
