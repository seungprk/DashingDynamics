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
    
    var size = CGSize(width: 10, height: 10)
    
    override init() {
        super.init()
        
        // Energy Matter Texture Setup
        let energyMatterAnimatedAtlas = SKTextureAtlas(named: "energyMatter")
        var energyMatterTextureFrames = [SKTexture]()
        for i in 1...energyMatterAnimatedAtlas.textureNames.count {
            let textureName = "energyMatter\(i)"
            energyMatterTextureFrames.append(energyMatterAnimatedAtlas.textureNamed(textureName))
        }
        let spriteComponent = SpriteComponent(textureFrames: energyMatterTextureFrames)

        // PhysicsBody Setup
        let physicsBody = SKPhysicsBody(circleOfRadius: GameplayConfiguration.EnergyMatter.size.height/2)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.energyMatter
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
        
        // Animation
        let idleAction = SKAction.animate(with: energyMatterTextureFrames, timePerFrame: 1)
        let loopIdleAction = SKAction.repeatForever(idleAction)
        spriteComponent.node.run(loopIdleAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
