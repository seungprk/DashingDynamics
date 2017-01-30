//
//  CreepDeathManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 1/29/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreepDeathManager {
    var scene: GameScene!
    let creepNode = SKNode()
    let physicsContactNode = SKSpriteNode()
    let graphicsNode = SKNode()
    let size: CGSize!
    var timeElapsed: TimeInterval = 0
    
    init(scene: GameScene) {
        self.scene = scene
        size = CGSize(width: scene.size.width, height: scene.size.height / 2)
        
        physicsContactNode.size = size
        
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.creepDeath
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.isDynamic = false
        
        physicsContactNode.physicsBody = physicsBody
        physicsContactNode.position = CGPoint(x: 0, y: -scene.size.height)
        
        let creepUp = SKAction.moveBy(x: 0, y: 3, duration: 1)
        let creepUpRepeat = SKAction.repeatForever(creepUp)
        physicsContactNode.run(creepUpRepeat)
        
        scene.addChild(creepNode)
        creepNode.addChild(physicsContactNode)
    }
    
    func updatePhysicsBodyPos(cameraYPos: CGFloat) {
        let topOfContactNode = physicsContactNode.position.y + physicsContactNode.size.height / 2
        let botOfCamera = cameraYPos - scene.size.height / 2
        if topOfContactNode < botOfCamera {
            physicsContactNode.position.y =  botOfCamera - physicsContactNode.size.height / 2
        }
    }
}
