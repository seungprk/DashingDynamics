//
//  Field.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 8/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//


import SpriteKit
import GameplayKit

class Laser: GKEntity {
    
    var isActivated = false
    static var idIncrement = 0
    var laserTextures: [SKTexture]!
    let id: String
    
    init(frame: CGRect) {
        let name = "laser\(Laser.idIncrement)"
        Laser.idIncrement += 1
        id = name
        
        super.init()
        
        // Setup Sprite
        let laserAtlas = SKTextureAtlas(named: "laser")
        laserTextures = [SKTexture]()
        for range in 1...laserAtlas.textureNames.count {
            let texture = laserAtlas.textureNamed("laser-\(range)")
            texture.filteringMode = .nearest
            laserTextures.append(texture)
        }
        let spriteComponent = SpriteComponent(textureFrames: laserTextures)
        
        // Setup Physicsbody
        let physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.frame.size)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.laser
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        
        physicsBody.isDynamic = true
        spriteComponent.node.physicsBody = physicsBody
        spriteComponent.node.name = name
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody)
        
        addComponent(spriteComponent)
        addComponent(physicsComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var laserElapsed: TimeInterval = 0
    
    override func update(deltaTime seconds: TimeInterval) {
        laserElapsed += seconds
        
        if laserElapsed > 2 {
            laserElapsed = 0
            let spriteComponent = component(ofType: SpriteComponent.self)
            let animateAction = SKAction.animate(with: laserTextures, timePerFrame: 0.1)
            if isActivated {
                spriteComponent?.node.texture = spriteComponent?.textureFrames[0]
                isActivated = !isActivated
            } else {
                spriteComponent?.node.run(animateAction, completion: {
                    self.isActivated = !self.isActivated
                })
            }
        }
    }

}

