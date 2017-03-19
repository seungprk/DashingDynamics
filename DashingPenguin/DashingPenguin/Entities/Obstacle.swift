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
    
    init(size: CGSize, texture: SKTexture? = nil) {
        super.init()
        self.size = size
        let spriteComponent: SpriteComponent!
        if texture == nil {
            spriteComponent = SpriteComponent(color: UIColor.red, size: size)
        } else {
            spriteComponent = SpriteComponent(texture: texture!)
        }
        spriteComponent.node.name = "obstacle"
        
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
        
        // Animate
        let obstacleAtlas = SKTextureAtlas(named: "obstacle")
        
        let obstacleTextures = [obstacleAtlas.textureNamed("obstacle-2"),
                                       obstacleAtlas.textureNamed("obstacle-3"),
                                       obstacleAtlas.textureNamed("obstacle-4"),
                                       obstacleAtlas.textureNamed("obstacle-4"),
                                       obstacleAtlas.textureNamed("obstacle-3"),
                                       obstacleAtlas.textureNamed("obstacle-2"),
                                       obstacleAtlas.textureNamed("obstacle-1"),
                                       obstacleAtlas.textureNamed("obstacle-1")]
        for texture in obstacleTextures {
            texture.filteringMode = .nearest
        }
        
        let rotate = SKAction.animate(with: obstacleTextures, timePerFrame: 0.2)
        let wait = SKAction.wait(forDuration: 0.4)
        let rotateAnimation = SKAction.repeatForever(SKAction.sequence([rotate, wait]))
        spriteComponent.node.run(rotateAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
