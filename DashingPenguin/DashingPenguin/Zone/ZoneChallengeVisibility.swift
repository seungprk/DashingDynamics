//
//  ZoneB.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneChallengeVisibility: Zone {
    
    var filterNode: SKSpriteNode!
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.generateRandomBlocks(amount: 3)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.entities.first as! Platform!
        
        setupFilterNode()
    }
    
    func setupFilterNode() {
        filterNode = SKSpriteNode(imageNamed: "deathcover")
        filterNode.color = UIColor.red//UIColor(red: 31/255, green: 151/255, blue: 255/255, alpha: 1.0)
        filterNode.colorBlendFactor = 1.0
        filterNode.size = scene.size
        filterNode.zPosition = GameplayConfiguration.HeightOf.filter
        filterNode.alpha = 0
        scene.sceneCamEffectNode.addChild(filterNode)
    }
    
    override func enterEvent() {
        super.enterEvent()
        
        if hasBeenEntered == false {
            hasBeenEntered = true
            
            // Setup Challenge Activation
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeAction = SKAction.sequence([fadeIn,
                                                SKAction.wait(forDuration: 1),
                                                fadeOut,
                                                SKAction.wait(forDuration: 1)])
            let filterRepeatAction = SKAction.repeatForever(fadeAction)
            
            // Activate Challenge
            filterNode.run(filterRepeatAction, withKey: "filterRepeatAction")
        }
    }
    
    override func exitEvent() {
        if hasBeenExited == false {
            super.exitEvent()
            
            filterNode.removeAction(forKey: "filterRepeatAction")
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            filterNode.run(fadeOut)
            hasBeenExited = true
        }
    }
    
}
