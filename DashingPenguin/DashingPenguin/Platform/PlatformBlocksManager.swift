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
    
    func checkIfBlockNeedsToBeAdded() {
        let yPosOfTopOfScreen = (scene.cameraNode?.position.y)! + scene.size.height/2
        let yPosOfTopOfLastBlock = (blocks.last?.position.y)! + (blocks.last?.size.height)!/2
        if yPosOfTopOfScreen >= yPosOfTopOfLastBlock {
            addBlock()
        }
    }
    
    func checkIfBlockNeedsToBeRemoved() {
        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
        let yPosOfTopOfFirstBlock = (blocks.first?.position.y)! + (blocks.first?.size.height)!/2
        if yPosOfBottomOfScreen >= yPosOfTopOfFirstBlock {
            blocks.first?.removeFromParent()
            blocks.removeFirst()
        }
    }
    func addBlock() {
        let newBlock = PlatformBlock(size: CGSize(width: scene.size.width, height: 300))
        let lastBlock = (blocks.last)!
        let nextBlockPos = CGPoint(x: lastBlock.position.x, y: lastBlock.position.y + lastBlock.size.height/2 + newBlock.size.height/2)
        newBlock.position = nextBlockPos
        scene.addChild(newBlock)
        blocks.append(newBlock)
    }
}
