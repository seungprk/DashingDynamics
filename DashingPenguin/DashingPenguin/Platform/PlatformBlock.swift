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
    
    init(size: CGSize) {
        self.size = size
        super.init()
        print("PlatformBlock Object Created")
        
        // Background for Debug
        addChild(SKSpriteNode(color: UIColor.blue(), size: self.size))
        
        // Setup Platforms
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.componentForClass(SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: 0, y: -size.height/2 + firstPlatformSpriteNode.size.height/2)
        addChild(firstPlatformSpriteNode)
        platforms.append(firstPlatform)
        
        let secondPlatform = Platform()
        let secondPlatformSpriteNode = secondPlatform.componentForClass(SpriteComponent.self)!.node
        secondPlatformSpriteNode.position = CGPoint(x: 0, y: secondPlatformSpriteNode.size.height/2)
        addChild(secondPlatformSpriteNode)
        platforms.append(secondPlatform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
