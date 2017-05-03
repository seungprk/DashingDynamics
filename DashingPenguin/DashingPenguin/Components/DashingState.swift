//
//  DashingState.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DashingState: GKState, WallContactDelegate {
    
    unowned var entity: Player
    
    var elapsedTime: TimeInterval = 0.0
    
    required init(entity: Player) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Remove DashEndingState's visual effects
        entity.component(ofType: MovementComponent.self)?.dashCount += 1
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.removeAllActions()
            spriteComponent.node.alpha = 1
        }
        
        // Reset elapsed time
        elapsedTime = 0.0
        
        // Give initial impulse to the player
        if let spriteComponent = self.entity.component(ofType: SpriteComponent.self),
            let dashVelocity = self.entity.component(ofType: MovementComponent.self)?.dashVelocity {
            spriteComponent.node.physicsBody?.applyImpulse(dashVelocity)
        }
        
        AudioManager.sharedInstance.play("energy-burst")
        
        // Trailing Effect
        var prevTime: CGFloat = 0.0
        var accumTime: CGFloat = 0.0
        
        if let playerNode = entity.component(ofType: SpriteComponent.self)?.node {
            let gameScene = playerNode.scene as! GameScene
            
            let trailAction = SKAction.customAction(withDuration: GameplayConfiguration.Player.dashDuration) {
                node, elapsedTime in
                
                let deltaTime = elapsedTime - prevTime
                accumTime += deltaTime
                prevTime = elapsedTime
                
                if elapsedTime == 0.0 || accumTime > 0.05 {
                    accumTime = 0.0
                    if let node = node as? SKSpriteNode {
                        
                        let trailNode = SKSpriteNode(texture: playerNode.texture)
                        trailNode.position = node.position
                        trailNode.zPosition = node.zPosition - 0.0001
                        trailNode.alpha = 0.5
                        gameScene.sceneEffectNode.addChild(trailNode)
                        
                        let delayRemoveSequence = SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.removeFromParent()])
                        trailNode.run(delayRemoveSequence)
                    }
                }
            }
            
            playerNode.run(trailAction)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        elapsedTime += seconds

        // When dashing duration is up,
        // Stop the player and enter DashEndingState
        if elapsedTime > GameplayConfiguration.Player.dashDuration {
            if let spriteComponent = self.entity.component(ofType: SpriteComponent.self) {
                spriteComponent.node.physicsBody?.velocity = CGVector.zero
            }
            self.stateMachine?.enter(DashEndingState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DashEndingState.Type, is LandedState.Type, is DeathState.Type:
            return true
        default:
            return false
        }
    }
    
    func didContactWall() {
        print("HITWALL")
    }
}
