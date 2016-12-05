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
    var energyMatterTextureFrames: [SKTexture]!
    
    override init() {
        super.init()

        // Energy Matter Texture Setup
        let energyMatterAnimatedAtlas = SKTextureAtlas(named: "energymatter")
        let energyMatterTextureFrames = [energyMatterAnimatedAtlas.textureNamed("energymatter-1"),
                                         energyMatterAnimatedAtlas.textureNamed("energymatter-2"),
                                         energyMatterAnimatedAtlas.textureNamed("energymatter-2"),
                                         energyMatterAnimatedAtlas.textureNamed("energymatter-2")]
        for texture in energyMatterTextureFrames {
            texture.filteringMode = .nearest
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
        
        // Bob animation
        let bobUp = SKAction.moveBy(x: 0, y: 3, duration: 1)
        let bobDown = SKAction.moveBy(x: 0, y: -3, duration: 1)
        let wait = SKAction.wait(forDuration: 0.5)
        let bobAnimation = SKAction.repeatForever(SKAction.sequence([bobUp, wait, bobDown, wait]))
        spriteComponent.node.run(bobAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
