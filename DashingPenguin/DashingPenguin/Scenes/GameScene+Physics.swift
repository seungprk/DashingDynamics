//
//  GameScene+Physics.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/24/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        let firstBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            contact.bodyB : contact.bodyA
        
        print(firstBody.categoryBitMask)
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            player?.isOnPlatform = true
            print("Player over platform")
            
        default:
            break
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            contact.bodyB : contact.bodyA
        
        print(firstBody.categoryBitMask, secondBody.categoryBitMask)
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            player?.isOnPlatform = false
            print("! Player NOT on platform")
            
        default:
            break
        }
    }
}
