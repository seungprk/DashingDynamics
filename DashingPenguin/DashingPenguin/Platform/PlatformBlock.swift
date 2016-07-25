//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlock: SKNode {
    
    var platforms = [Platform]()
    var size: CGSize!
    var nextBlockFirstPlatformXPos: CGFloat!
    
    override init() {
        super.init()
        print("PlatformBlock Object Created")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextBlockDelta(fromX firstPlatXPos: CGFloat, withDist randomDist: CGFloat, inScene scene: GameScene) -> CGVector {
        let platformSize = Platform().size
        
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
        
        return CGVector(dx: xDelta, dy: yDelta)
    }
}
