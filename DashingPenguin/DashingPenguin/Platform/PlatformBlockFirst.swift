//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockFirst: PlatformBlock {
    
    init(scene: GameScene) {
        super.init()
        size = CGSize(width: scene.size.width, height: 200)
        
        // Background for Debug
        //addChild(SKSpriteNode(color: UIColor.blue, size: self.size))
        //addChild(SKSpriteNode(color: UIColor.red, size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platforms
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.component(ofType: SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: 0, y: -size.height/2 - firstPlatformSpriteNode.size.height/2 + GameplayConfiguration.Platform.size.height)
        
        addChild(firstPlatformSpriteNode)
        entities.append(firstPlatform)
        
        // Setup X Position of First Platform for Next Block
        nextBlockFirstPlatformXPos = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
