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
    var begXPos: CGFloat!
    
    init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        self.scene = scene
        self.begXPos = begXPos
        self.begYPos = begYPos
        print("PlatformBlocksManager Object created")
        
        // Create and Place First Block
        let firstBlock = PlatformBlockSingleDash(scene: scene, firstPlatXPos: begXPos)
        firstBlock.position = CGPoint(x: 0, y: begYPos + firstBlock.size.height/2)
        
        setInitialZPos(for: firstBlock)
        scene.sceneEffectNode.addChild(firstBlock)
        blocks.append(firstBlock)
    }
    
    func addBlock(withType: String) {
        let newBlock = selectBlock(withType: withType)!
        let lastBlock = (blocks.last)!
        newBlock.position = CGPoint(x: 0, y: lastBlock.position.y + lastBlock.size.height/2 + newBlock.size.height/2)
        
        setInitialZPos(for: newBlock)
        scene.sceneEffectNode.addChild(newBlock)
        blocks.append(newBlock)
    }
    
    func selectBlock(withType: String) -> PlatformBlock? {
        switch withType {
        case "SingleDash":
            return PlatformBlockSingleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "DoubleDash":
            return PlatformBlockDoubleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "ObstacleDoubleDash":
            return PlatformBlockObstacleDoubleDash(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "Moving":
            return PlatformBlockMoving(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "ObstacleLaser":
            return PlatformBlockObstacleLaser(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "ObstacleWall":
            return PlatformBlockObstacleWall(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        case "EnergyMatter":
            return PlatformBlockEnergyMatter(scene: scene, firstPlatXPos: (blocks.last?.nextBlockFirstPlatformXPos)!)
        default:
            print("Block selection Failed")
            return nil
        }
    }
    
    func generateRandomBlocks(amount: Int) {
        for _ in 0..<amount {
            let randomize = arc4random_uniform(6)
            switch randomize {
            case 0:
                addBlock(withType: "SingleDash")
            case 1:
                addBlock(withType: "DoubleDash")
            case 2:
                addBlock(withType: "ObstacleDoubleDash")
            case 3:
                addBlock(withType: "Moving")
            case 4:
                addBlock(withType: "ObstacleLaser")
            case 5:
                addBlock(withType: "ObstacleWall")
            default:
                break
            }
        }
    }
    
    func getLastBlockEndY() -> CGFloat {
        return (blocks.last?.position.y)! + (blocks.last?.size.height)!/2
    }
    
    func removeAllBlocks() {
        for block in blocks {
            block.removeEntities()
        }
        blocks.removeAll()
    }
    
    func setInitialZPos(for block: PlatformBlock) {
        for entity in block.entities {
            if let spriteComp = entity.component(ofType: SpriteComponent.self) {
                let spriteNode = spriteComp.node
                let positionInScene = scene.convert(spriteNode.position, from: (spriteNode.parent!))
                if entity is Platform {
                    spriteNode.zPosition = -(positionInScene.y + spriteNode.size.height / 2) / 1000
                } else {
                    spriteNode.zPosition = -positionInScene.y / 1000
                }
            }
            if let spriteComp = entity.component(ofType: TiledWallSpriteComponent.self) {
                let spriteNode = spriteComp.node
                let positionInScene = scene.convert(spriteNode.position, from: (spriteNode.parent!))
                for node in spriteNode.children {
                    node.zPosition = -positionInScene.y / 1000
                }
            }
        }
    }
}
