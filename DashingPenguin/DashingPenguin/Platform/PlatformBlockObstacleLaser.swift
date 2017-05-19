//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockObstacleLaser: PlatformBlock {
    
    var laser: Laser!
    
    init(scene: GameScene, firstPlatXPos: CGFloat) {
        super.init()
        
        let platformSize = Platform().size
        
        // Get Random Distance
        let maxDash = GameplayConfiguration.TouchControls.maxDistance
        let distance = sqrt(2) * maxDash
        
        // Get Random Angle, Limit by Either Width of Screen or Next Platform Should be Higher Y
        let nextDelta = nextBlockDelta(fromX: firstPlatXPos, withDist: distance, inScene: scene)
        
        // Setup Size of Block and X Position of First Platform in the Next Block
        size = CGSize(width: scene.size.width, height: nextDelta.dy)
        nextBlockFirstPlatformXPos = firstPlatXPos + nextDelta.dx
        
        // Background for debug
        //addChild(SKSpriteNode(color: UIColor.purple, size: self.size))
        //addChild(SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platform
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.component(ofType: SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos, y: -size.height/2 - firstPlatformSpriteNode.size.height/2 + GameplayConfiguration.Platform.size.height)
        addChild(firstPlatformSpriteNode)
        entities.append(firstPlatform)
        
        // Setup Laser
        laser = Laser(frame: scene.frame)
        let laserSpriteNode = laser.component(ofType: SpriteComponent.self)!.node
        laserSpriteNode.position = CGPoint(x: 0, y: GameplayConfiguration.Platform.size.height / 2)
        addChild(laserSpriteNode)
        entities.append(laser)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
