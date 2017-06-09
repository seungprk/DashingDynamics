//
//  DeathState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DeathState: GKState {
    
    unowned var entity: Player
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        print("DEAD")
        
        // Stop gameplay
        let spriteComponent = self.entity.component(ofType: SpriteComponent.self)
        spriteComponent?.node.removeAllActions()
        spriteComponent?.node.physicsBody?.velocity = CGVector.zero
        entity.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity = CGVector.zero
        let gameScene = spriteComponent?.node.scene as! GameScene
        gameScene.cameraFollowsPlayer = false
        spriteComponent?.node.physicsBody?.fieldBitMask = GameplayConfiguration.PhysicsBitmask.none
        
        // Remove all platform actions
        for child in gameScene.sceneEffectNode.children {
            if child.name == "platformBlock" {
                for subChild in child.children {
                    if subChild.name == "platform" {
                        subChild.removeAllActions()
                    }
                }
            }
        }
        
        // Stop lasers turning on and off
        gameScene.zoneManager.turnOffLasers()
        
        if entity.death == "laser" {
            // Laser Death Animation
            let animationTime: TimeInterval = 0.5
            
            // Setup the bright yellow node in shape of player
            let yellowCropNode = SKCropNode()
            let maskNode = SKSpriteNode(texture: spriteComponent?.node.texture)
            yellowCropNode.maskNode = maskNode
            let yellowBoxNode = SKSpriteNode(imageNamed: "playerdeathyellow")
            yellowCropNode.alpha = 1
            yellowCropNode.addChild(yellowBoxNode)
            spriteComponent?.node.addChild(yellowCropNode)
            
            let removeOriginal = SKAction.run({
                spriteComponent?.node.texture = nil
            })
            let fadeOut = SKAction.fadeOut(withDuration: animationTime / 5 * 4)
            let fadeAndRemove = SKAction.group([removeOriginal, fadeOut])
            let yellowTrans = SKAction.fadeIn(withDuration: animationTime / 5)
            spriteComponent?.node.run(SKAction.sequence([yellowTrans, fadeAndRemove]))
            
            AudioManager.sharedInstance.play("phase-death")
            
        } else if entity.death == "creep" {
            // Creep Death Animation
            let animationTime: TimeInterval = 0.5
            
            // Setup the bright yellow node in shape of player
            let yellowCropNode = SKCropNode()
            let maskNode = SKSpriteNode(texture: spriteComponent?.node.texture)
            yellowCropNode.maskNode = maskNode
            let yellowBoxNode = SKSpriteNode(imageNamed: "playerdeathblue")
            yellowCropNode.alpha = 1
            yellowCropNode.addChild(yellowBoxNode)
            spriteComponent?.node.addChild(yellowCropNode)
            
            let removeOriginal = SKAction.run({
                spriteComponent?.node.texture = nil
            })
            let fadeOut = SKAction.fadeOut(withDuration: animationTime / 5 * 4)
            let fadeAndRemove = SKAction.group([removeOriginal, fadeOut])
            let yellowTrans = SKAction.fadeIn(withDuration: animationTime / 5)
            spriteComponent?.node.run(SKAction.sequence([yellowTrans, fadeAndRemove]))
            
            AudioManager.sharedInstance.play("phase-death")
            
        } else {
            // Falling Animation
            let animationTime: TimeInterval = 0.5
            let downAction = SKAction.moveBy(x: 0, y: -30, duration: animationTime)
            let shrinkAction = SKAction.scale(to: 0.01, duration: animationTime)
            let fallAction = SKAction.group([downAction, shrinkAction])
            spriteComponent?.node.run(fallAction, completion: {
                spriteComponent?.node.removeFromParent()
            })
            
            AudioManager.sharedInstance.play("power-down")
            AudioManager.sharedInstance.setVolume("power-down", volume: 1.5, dur: 0)
        }
    }
}
