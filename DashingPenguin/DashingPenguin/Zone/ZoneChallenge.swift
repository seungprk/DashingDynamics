//
//  ZoneB.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneChallenge: Zone {
    
    override init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        super.init(scene: scene, begXPos: begXPos, begYPos: begYPos)
        platformBlocksManager.generateRandomBlocks(amount: 1)
        initSize()
        firstPlatform = platformBlocksManager.blocks.first?.platforms.first
        firstPlatform.component(ofType: SpriteComponent.self)?.node.color = UIColor.darkGray
    }
    
    func enterEvent() {
        if hasBeenEntered == false {
            print("challenge zone entered")
            let flashingLabel = SKLabelNode(text: "CHALLENGE!!")
            flashingLabel.fontColor = UIColor.black
            flashingLabel.position = CGPoint(x: 0, y: 0)
            scene.cameraNode?.addChild(flashingLabel)
            
            let flashingAction = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 1)])
            flashingLabel.run(flashingAction)
            
            hasBeenEntered = true
        }
    }
}
