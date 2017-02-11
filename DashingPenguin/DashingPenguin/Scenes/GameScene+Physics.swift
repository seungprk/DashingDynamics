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
                self.player?.death = "laser"
                self.player?.component(ofType: MovementComponent.self)?.stateMachine.enter(DeathState.self)
            }
            
        // Player and creep death intersect
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.creepDeath):
            self.player?.death = "creep"
            self.player?.component(ofType: MovementComponent.self)?.stateMachine.enter(DeathState.self)
        
        // Player and energy matter intersect
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.energyMatter):
            if secondBody.node?.parent != nil {
                player?.component(ofType: MovementComponent.self)?.dashCount -= 1
                scoreManager.incrementPlatformPart()
                
                // Energy Matter Texture Setup
                let energyMatterAnimatedAtlas = SKTextureAtlas(named: "energymatter")
                let energyMatterTextureFrames = [energyMatterAnimatedAtlas.textureNamed("energymatter-1"),
                                                 energyMatterAnimatedAtlas.textureNamed("energymatter-2"),
                                                 energyMatterAnimatedAtlas.textureNamed("energymatter-2"),
                                                 energyMatterAnimatedAtlas.textureNamed("energymatter-2")]
                for texture in energyMatterTextureFrames {
                    texture.filteringMode = .nearest
                }
                
                // Animate Energy Matter and Remove
                let glowAction = SKAction.animate(with: energyMatterTextureFrames, timePerFrame: 0.0125)
                let shrinkAction = SKAction.scale(by: 0.01, duration: 0.1)
                let removeSpriteAction = SKAction.run({
                    secondBody.node?.removeFromParent()
                })
                secondBody.node?.run(SKAction.sequence([glowAction, removeSpriteAction]))
                secondBody.node?.run(shrinkAction)
                secondBody.node?.physicsBody = nil
                
                // Animate Player
                let spriteComponent = player?.component(ofType: SpriteComponent.self)
                let rectNode = SKSpriteNode(imageNamed: "lightbar")
                rectNode.position = CGPoint(x: 0, y: -((spriteComponent?.node.texture?.size().height)! / 2) + ((rectNode.texture?.size().height)! / 2))
                rectNode.zPosition = 10
                spriteComponent?.node.addChild(rectNode)
                
                let moveUp = SKAction.moveBy(x: 0, y: (spriteComponent?.node.texture?.size().height)! - (rectNode.texture?.size().height)! / 2 , duration: 0.1)
                rectNode.run(moveUp, completion: {
                    rectNode.removeFromParent()
                })
            }
            
//        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.obstacle):
//            wallContactDelegate?.didContactWall()
            
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
