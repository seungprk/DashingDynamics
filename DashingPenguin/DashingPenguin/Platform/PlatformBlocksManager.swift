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
    var begZPos: CGFloat!
    
    init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat, begZPos: CGFloat) {
        self.scene = scene
        self.begXPos = begXPos
        self.begYPos = begYPos
        self.begZPos = begZPos
        print("PlatformBlocksManager Object created")
        
        // Create and Place First Block
        let firstBlock = PlatformBlockSingleDash(scene: scene, firstPlatXPos: begXPos)
        firstBlock.position = CGPoint(x: 0, y: begYPos + firstBlock.size.height/2)
        firstBlock.entities.first?.component(ofType: SpriteComponent.self)?.node.zPosition = begZPos - 1
        scene.addChild(firstBlock)
        blocks.append(firstBlock)
    }
    
    func addBlock(withType: String) {
        let newBlock = selectBlock(withType: withType)!
        let lastBlock = (blocks.last)!
        newBlock.position = CGPoint(x: lastBlock.position.x, y: lastBlock.position.y + lastBlock.size.height/2 + newBlock.size.height/2)
        
        // Set Last Block Sprite Node
        var lastBlockPlatSpriteNode: SKSpriteNode! = nil
        if lastBlock is PlatformBlockEnergyMatter {
            lastBlockPlatSpriteNode = lastBlock.children.last as! SKSpriteNode
        } else {
            lastBlockPlatSpriteNode = lastBlock.entities.last?.component(ofType: SpriteComponent.self)?.node
            if lastBlock is PlatformBlockObstacleWall {
                lastBlockPlatSpriteNode = lastBlock.entities.last?.component(ofType: TiledWallSpriteComponent.self)?.node.children[0] as! SKSpriteNode
            }
        }
        
        // Set New Block Sprite Node
        if newBlock is PlatformBlockEnergyMatter {
            let newBlockPlatSpriteNode = newBlock.children.first as! SKSpriteNode
            newBlockPlatSpriteNode.zPosition = (lastBlockPlatSpriteNode?.zPosition)! - 1
        } else {
            var counter: CGFloat = 0 //used to make sure consecutive zPosition changes are applied correctly
            for entity in newBlock.entities {
                if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
                    if spriteNode.name == "platform" || spriteNode.name == "obstacle" || spriteNode.name == "tiled wall" {
                        spriteNode.zPosition = (lastBlockPlatSpriteNode?.zPosition)! - (1 + counter)
                        counter += 1
                    }
                }
                if let tiledNode = entity.component(ofType: TiledWallSpriteComponent.self)?.node {
                    for node in tiledNode.children {
                        node.zPosition = (lastBlockPlatSpriteNode?.zPosition)! - (1 + counter)
                        print(node.zPosition)
                    }
                    counter += 1
                }
            }
        }
        
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
}
