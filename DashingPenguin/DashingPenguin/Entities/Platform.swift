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

    let size = GameplayConfiguration.Platform.size
    var activated = false
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "bigPlatform1"))
        spriteComponent.node.name = "platform"
        spriteComponent.node.entity = self
        
        let physicsPosition = CGPoint(x: spriteComponent.node.position.x, y: spriteComponent.node.position.y + spriteComponent.node.size.height / 2 - size.height / 2)
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: physicsPosition)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.isDynamic = false
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    /*
     * Initializer for a moving platform.
     */
    init(scene: SKScene, slidingMagnitude: CGFloat, yPosition: CGFloat) {
        super.init()
        
        let wallWidth = SKTexture(imageNamed: "wall").size().width
        
        let possibleCenterMin = size.width / 2
            + slidingMagnitude / 2
            - scene.frame.width / 2
            + wallWidth
        
        let possibleCenterMax = scene.frame.width - size.width / 2
            - slidingMagnitude / 2
            - scene.frame.width / 2
            - wallWidth
        
        let randomSlidingCenterX = CGFloat(arc4random_uniform(UInt32(possibleCenterMax - possibleCenterMin))) + possibleCenterMin
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "bigPlatform1"))
        spriteComponent.node.name = "platform"
        spriteComponent.node.entity = self
        
        let physicsPosition = CGPoint(x: spriteComponent.node.position.x, y: spriteComponent.node.position.y + spriteComponent.node.size.height / 2 - size.height / 2)
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: physicsPosition)
        
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.fieldBitMask = GameplayConfiguration.PhysicsBitmask.none
        
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
    
    func landingActivate() {
        if activated == false {
            let landedTexture = SKTexture(imageNamed: "bigPlatform2")
            landedTexture.filteringMode = .nearest
            
            let spriteNode = component(ofType: SpriteComponent.self)?.node
            spriteNode?.texture = landedTexture
            let gameScene = spriteNode?.scene as! GameScene
            gameScene.scoreManager.incrementPlatformPart()
            
            activated = true
            
            AudioManager.sharedInstance.play("beep-low")
        }
    }
    
}
