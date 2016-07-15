//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockSingleDash: PlatformBlock {
    
    init(scene: GameScene, firstPlatXPos: CGFloat) {
        super.init()
        size = CGSize(width: scene.size.width, height: 200)
        
        // Background for Debug
        addChild(SKSpriteNode(color: UIColor.red(), size: self.size))
        
        // Setup Platform
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.componentForClass(SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos, y: -size.height/2 + firstPlatformSpriteNode.size.height/2)
        addChild(firstPlatformSpriteNode)
        platforms.append(firstPlatform)
        
        // Setup X Position of First Platform for Next Block
        nextBlockFirstPlatformXPos = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
