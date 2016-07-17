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
        
        let platformSize = Platform().size
        
        // Get Random Distance
        let rMax = GameplayConfiguration.TouchControls.maxDistance
        let rMin = sqrt(2) * platformSize.height/2 * 1.5
        let randomDist = rMin + CGFloat(arc4random_uniform(UInt32(rMax-rMin)) + 1)
        
        // Get Random Angle, Limit by Either Width of Screen or Next Platform Should be Higher Y
        let distToRightEdge = scene.size.width/2 - firstPlatXPos - platformSize.width/2
        let distToLeftEdge = firstPlatXPos + scene.size.width/2 - platformSize.width/2
        
        let angleReducFromRightEdge = acos(distToRightEdge / randomDist)
        let angleReducFromLeftEdge = acos(distToLeftEdge / randomDist)
        let angleReducFromNextPlat = asin(platformSize.height / randomDist)
        
        var angleMin: CGFloat!
        if distToRightEdge < sqrt(randomDist * randomDist - platformSize.height * platformSize.height) {
            angleMin = angleReducFromRightEdge
        } else {
            angleMin = angleReducFromNextPlat
        }
        var maxReduction: CGFloat!
        if distToLeftEdge < sqrt(randomDist * randomDist - platformSize.height * platformSize.height) {
            maxReduction = angleReducFromLeftEdge
        } else {
            maxReduction = angleReducFromNextPlat
        }
        let angleMax = CGFloat.pi - maxReduction
        let randomAngle = CGFloat(arc4random()) / CGFloat(UInt32.max) * (angleMax - angleMin) + angleMin
        
        let yDelta = sin(randomAngle) * randomDist
        let xDelta = cos(randomAngle) * randomDist
        
        // Setup Size of Block and X Position of First Platform in the Next Block
        size = CGSize(width: scene.size.width, height: yDelta + platformSize.height)
        nextBlockFirstPlatformXPos = firstPlatXPos + xDelta
        
        // Background for debug
        addChild(SKSpriteNode(color: UIColor.red(), size: self.size))
        addChild(SKSpriteNode(color: UIColor.white(), size: CGSize(width: self.size.width - 2, height: self.size.height - 2)))
        
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
