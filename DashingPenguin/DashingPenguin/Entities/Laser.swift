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
    
    static var idIncrement = 0
    var laserTextures: [SKTexture]!
    let id: String
    var laserOn = true
    
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
        
        physicsBody.isDynamic = false
        spriteComponent.node.physicsBody = nil
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
        
        if laserElapsed > 2 && laserOn {
            laserElapsed = 0
            
            let spriteComponent = component(ofType: SpriteComponent.self)
            let spriteNode = component(ofType: SpriteComponent.self)?.node
            let savedPhysicsBody = component(ofType: PhysicsComponent.self)?.physicsBody
            
            // If deactivated, activate
            if spriteNode?.physicsBody == nil {
                let animateAction = SKAction.animate(with: laserTextures, timePerFrame: 0.1)
                spriteNode?.run(animateAction, completion: {
                    spriteNode?.physicsBody = savedPhysicsBody
                })
                AudioManager.sharedInstance.play("laser-charge")
                AudioManager.sharedInstance.setVolume("laser-charge", volume: 0.7, dur: 0)
            // If activated, deactivate
            } else {
                spriteNode?.texture = spriteComponent?.textureFrames[0]
                spriteNode?.physicsBody = nil
            }
        }
    }

}

