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
    
    let id: String
    
    init(frame: CGRect) {
        let name = "laser\(Laser.idIncrement)"
        Laser.idIncrement += 1
        id = name
        
        super.init()
        
        // Setup Sprite
        let laserTexture1 = SKTexture(imageNamed: "laser1")
        let laserTexture2 = SKTexture(imageNamed: "laser2")
        let textureArray = [laserTexture1, laserTexture2]
        let spriteComponent = SpriteComponent(textureFrames: textureArray)
        
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
            
            let laserAtlas = SKTextureAtlas(named: "laser")
            var laserTextures = [SKTexture]()
            for range in 1...laserAtlas.textureNames.count {
                let texture = laserAtlas.textureNamed("laser-\(range)")
                texture.filteringMode = .nearest
                laserTextures.append(texture)
            }
            let animateAction = SKAction.animate(with: laserTextures, timePerFrame: 0.1)
            if isActivated {
                spriteComponent?.node.texture = spriteComponent?.textureFrames[0]
            } else {
                spriteComponent?.node.run(animateAction)
            }
            isActivated = !isActivated
        }
    }

}

