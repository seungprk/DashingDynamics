//
//  PlatformBlocksManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PlatformBlockType {
    case singleDash
    case doubleDash
    case obstacleDoubleDash
    case laserDoubleDash
}

class PlatformBlocksManager {
    
    var scene: GameScene!
    var blocks = [PlatformBlock]()
    var begYPos: CGFloat!
    
    init(scene: GameScene, begYPos: CGFloat) {
        self.scene = scene
        self.begYPos = begYPos
        print("PlatformBlocksManager Object created")
        
        // Create and Place First Block
        let firstBlock = PlatformBlockFirst(scene: scene)
        firstBlock.position = CGPoint(x: 0, y: begYPos + firstBlock.size.height/2)
        scene.addChild(firstBlock)
        blocks.append(firstBlock)
    }
    
    func addBlock(withType: String) {
        let newBlock = selectBlock(withType: withType)!
        let lastBlock = (blocks.last)!
        newBlock.position = CGPoint(x: lastBlock.position.x, y: lastBlock.position.y + lastBlock.size.height/2 + newBlock.size.height/2)
        scene.addChild(newBlock)
        blocks.append(newBlock)
    }
    
    func selectBlock(withType: String) -> PlatformBlock? {
        switch withType {
        case "SingleDash":
            return PlatformBlockSingleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "DoubleDash":
            return PlatformBlockDoubleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "ObstacleDoubleDash":
            return PlatformBlockLaserDoubleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        default:
            print("Block selection Failed")
            return nil
        }
    }
}
