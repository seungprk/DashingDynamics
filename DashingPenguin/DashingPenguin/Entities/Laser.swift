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
        
        let spriteComponent = SpriteComponent(color: .yellow, size: CGSize(width: frame.width, height: 10))
        
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
            component(ofType: SpriteComponent.self)!.node.isHidden = component(ofType: SpriteComponent.self)!.node.isHidden ? false : true
            isActivated = component(ofType: SpriteComponent.self)!.node.isHidden ? false : true
        }
    }

}

