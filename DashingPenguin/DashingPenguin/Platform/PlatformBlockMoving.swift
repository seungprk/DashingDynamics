//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockMoving: PlatformBlock {
    
    init(scene: GameScene, firstPlatXPos: CGFloat) {
        super.init()
        
        let platformSize = Platform().size
        
        // Get Random Distance
        let rMax = GameplayConfiguration.TouchControls.maxDistance
        let rMin = sqrt(2) * platformSize.height/2 * 1.5
        let randomDist = rMin + CGFloat(arc4random_uniform(UInt32(rMax-rMin)) + 1)
        
        // Get Random Angle, Limit by Either Width of Screen or Next Platform Should be Higher Y
        let nextDelta = nextBlockDelta(fromX: firstPlatXPos, withDist: randomDist, inScene: scene)
        
        // Setup Size of Block and X Position of First Platform in the Next Block
        size = CGSize(width: scene.size.width, height: nextDelta.dy + platformSize.height)
        nextBlockFirstPlatformXPos = firstPlatXPos + nextDelta.dx
        
        // Background for debug
        addChild(SKSpriteNode(color: UIColor.red, size: self.size))
        addChild(SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platform
        let firstPlatform = Platform(scene: scene, slidingMagnitude: 50, yPosition: size.height / 2)
        let firstPlatformSpriteNode = firstPlatform.component(ofType: SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos,
                                                    y: -size.height/2 + firstPlatformSpriteNode.size.height/2)
        addChild(firstPlatformSpriteNode)
        firstPlatform.component(ofType: SlidingComponent.self)?.beginSliding()
        platforms.append(firstPlatform)
        
        // Setup X Position of First Platform for Next Block
        nextBlockFirstPlatformXPos = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
