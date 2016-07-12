//
//  PlatformBlocksManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlocksManager {
    
    var scene: GameScene!
    var blocks = [PlatformBlock]()
    
    init(scene: GameScene) {
        self.scene = scene
        print("PlatformBlocksManager Object created")
        
        // Create and Place First Block
        let firstBlock = PlatformBlock(size: CGSize(width: scene.size.width, height: 300))
        scene.addChild(firstBlock)
        blocks.append(firstBlock)
    }
    
    func addBlock() {
        let newBlock = PlatformBlock(size: CGSize(width: scene.size.width, height: 300))
        scene.addChild(newBlock)
        blocks.append(newBlock)
    }
}
