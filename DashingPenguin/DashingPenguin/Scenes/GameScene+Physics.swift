//
//  GameScene+Physics.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/24/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

protocol PlatformLandingDelegate {
    func markForLanding(platform: SKNode)
    func didExitPlatform()
}

protocol WallContactDelegate {
    func didContactWall()
}

extension GameScene: SKPhysicsContactDelegate {
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        let firstBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyB : contact.bodyA
                
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        
        // Player and platform intersect
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            physicsContactCount += 1
            guard let node = secondBody.node else { break }
            platformLandingDelegate?.markForLanding(platform: node)
            
        // Player and laser intersect
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.laser):
            guard let laserNode = secondBody.node else { break }
            guard let laserDelegate = self.laserIdDelegate else { break }
            
            if laserDelegate.isLaserActivated(for: laserNode) {
                self.player?.component(ofType: MovementComponent.self)?.stateMachine.enter(DeathState.self)
            }
        
        // Player and energy matter intersect
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.energyMatter):
            if secondBody.node?.parent != nil {
                print("Physics: dashCount -1")
                player?.component(ofType: MovementComponent.self)?.dashCount -= 1
                secondBody.node?.removeFromParent()
            }
            
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.obstacle):
            wallContactDelegate?.didContactWall()
            print(wallContactDelegate)
            print("HIT WALL")
            
        default:
            break
        }
        
        player?.isOnPlatform = physicsContactCount == 0 ? false : true
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody  = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyB : contact.bodyA
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            physicsContactCount -= 1
            platformLandingDelegate?.didExitPlatform()
            
        default:
            break
        }

        player?.isOnPlatform = physicsContactCount == 0 ? false : true
    }
}
