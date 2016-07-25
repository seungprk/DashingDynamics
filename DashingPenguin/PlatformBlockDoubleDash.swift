//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockDoubleDash: PlatformBlock {
    
    init(scene: GameScene, firstPlatXPos: CGFloat) {
        super.init()
        
        let platformSize = Platform().size
        
        // Get Random Distance
        let rMax = GameplayConfiguration.TouchControls.maxDistance * 2
        let rMin = sqrt(2) * platformSize.height/2 * 1.5 + GameplayConfiguration.TouchControls.maxDistance
        let randomDist = rMin + CGFloat(arc4random_uniform(UInt32(rMax-rMin)) + 1)
        
        // Get Random Angle, Limit by Either Width of Screen or Next Platform Should be Higher Y
        let nextDelta = nextBlockDelta(fromX: firstPlatXPos, withDist: randomDist, inScene: scene)
        
        // Setup Size of Block and X Position of First Platform in the Next Block
        size = CGSize(width: scene.size.width, height: nextDelta.dy + platformSize.height)
        nextBlockFirstPlatformXPos = firstPlatXPos + nextDelta.dx
        
        // Background for debug
        addChild(SKSpriteNode(color: UIColor.cyan(), size: self.size))
        addChild(SKSpriteNode(color: UIColor.white(), size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platform
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.componentForClass(SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos, y: -size.height/2 + firstPlatformSpriteNode.size.height/2)
        addChild(firstPlatformSpriteNode)
        platforms.append(firstPlatform)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
