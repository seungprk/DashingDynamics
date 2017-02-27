//
//  CreepDeathManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 1/29/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreepDeathManager {
    var scene: GameScene!
    let creepNode = SKNode()
    let tileRowOne = SKNode()
    let tileRowTwo = SKNode()
    let coverSpriteNode: SKSpriteNode!
    let hexTileSize: CGSize!
    let hexTileGapWidth: CGFloat = 12
    let hexTileDiagEdgeWidth: CGFloat = 8
    let defaultColor = UIColor(red: 31/255, green: 151/255, blue: 255/255, alpha: 1.0)
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Setup Cover Sprite
        let coverTexture = SKTexture(imageNamed: "deathcover")
        coverTexture.filteringMode = .nearest
        coverSpriteNode = SKSpriteNode(texture: coverTexture)
        coverSpriteNode.position.y = -scene.size.height * 2
        coverSpriteNode.zPosition = GameplayConfiguration.HeightOf.deathTile
        coverSpriteNode.color = defaultColor
        coverSpriteNode.colorBlendFactor = 1.0
        
        let heightScale = scene.size.height / scene.size.width
        coverSpriteNode.yScale = heightScale
        
        // Setup Tiles
        let tileTexture = SKTexture(imageNamed: "deathtile")
        tileTexture.filteringMode = .nearest
        hexTileSize = tileTexture.size()
        let hexTileWidth = hexTileSize.width
        
        // Get number of sprites needed to fill screen width
        let horizTilesNum = Int(scene.size.width) / Int(hexTileWidth + hexTileGapWidth) + 1
        
        // Set up sprites in tile rows one and two
        for index in 0..<horizTilesNum {
            // Row One Sprite
            let tileSpriteRowOne = SKSpriteNode(texture: tileTexture)
            let rightShiftPerTile = CGFloat(index) * (hexTileWidth + hexTileGapWidth - 1)
            let leftEdgePosOfTileWithGap = (-scene.size.width / 2) - hexTileDiagEdgeWidth + rightShiftPerTile
            tileSpriteRowOne.position.x = leftEdgePosOfTileWithGap + hexTileWidth / 2
            tileSpriteRowOne.position.y = -scene.size.height / 2
            tileSpriteRowOne.zPosition = GameplayConfiguration.HeightOf.deathTile
            tileSpriteRowOne.color = defaultColor
            tileSpriteRowOne.colorBlendFactor = 1.0
            
            let physicsBodyOne = SKPhysicsBody(texture: tileTexture, size: tileSpriteRowOne.size)
            physicsBodyOne.categoryBitMask = GameplayConfiguration.PhysicsBitmask.creepDeath
            physicsBodyOne.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
            physicsBodyOne.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
            physicsBodyOne.isDynamic = false
            tileSpriteRowOne.physicsBody = physicsBodyOne
            
            tileRowOne.addChild(tileSpriteRowOne)
            
            // Row Two Sprite
            let tileSpriteRowTwo = SKSpriteNode(texture: tileTexture)
            tileSpriteRowTwo.position.x = tileSpriteRowOne.position.x + hexTileGapWidth + hexTileDiagEdgeWidth
            tileSpriteRowTwo.position.y = tileSpriteRowOne.position.y + hexTileSize.height / 2
            tileSpriteRowTwo.zPosition = GameplayConfiguration.HeightOf.deathTile
            tileSpriteRowTwo.color = defaultColor
            tileSpriteRowTwo.colorBlendFactor = 1.0
            
            let physicsBodyTwo = SKPhysicsBody(texture: tileTexture, size: tileSpriteRowTwo.size)
            physicsBodyTwo.categoryBitMask = GameplayConfiguration.PhysicsBitmask.creepDeath
            physicsBodyTwo.collisionBitMask = GameplayConfiguration.PhysicsBitmask.none
            physicsBodyTwo.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.player
            physicsBodyTwo.isDynamic = false
            tileSpriteRowTwo.physicsBody = physicsBodyTwo
            
            tileRowTwo.addChild(tileSpriteRowTwo)
        }
        
        // Add Nodes
        scene.addChild(creepNode)
        creepNode.addChild(tileRowOne)
        creepNode.addChild(tileRowTwo)
        creepNode.addChild(coverSpriteNode)
        restartAnimateRows()
    }
    
    func updatePhysicsBodyPos(cameraYPos: CGFloat) {
        let twoHeight = tileRowTwo.children[0].position.y
        let oneHeight = tileRowOne.children[0].position.y
        let topOfContactNode = (hexTileSize.height / 2) + (twoHeight > oneHeight ? twoHeight : oneHeight)
        
        let botOfCamera = cameraYPos - scene.size.height / 2
        if topOfContactNode + 1 < botOfCamera { // +1 to cover for float inaccuracies
            restartAnimateRows()
        }
        print("Top of Contact: ", topOfContactNode, " Bot of Cam: ", botOfCamera)
    }
    
    func restartAnimateRows() {
        // Clear Actions
        creepNode.removeAllActions()
        coverSpriteNode.removeAllActions()
        for node in tileRowOne.children {
            node.removeAllActions()
        }
        for node in tileRowTwo.children {
            node.removeAllActions()
        }
        
        // Reposition
        for node in tileRowTwo.children { node.position.y = (scene.cameraNode?.position.y)! - (scene.size.height / 2) - (hexTileSize.height / 2) }
        for node in tileRowOne.children { node.position.y = tileRowTwo.children[0].position.y - hexTileSize.height / 2 }
        coverSpriteNode.position.y = tileRowTwo.children[0].position.y - coverSpriteNode.size.height / 2
        
        // Random move up of hexagons
        let tickSec: TimeInterval = 1
        let startWaitSec: TimeInterval = 1
        
        // Setup move up animation
        let arrayCount = tileRowOne.children.count
        let setTiny = SKAction.scale(to: 0, duration: 0)
        let moveUp = SKAction.moveBy(x: 0, y: hexTileSize.height, duration: 0)
        let expand = SKAction.scale(to: 1.0, duration: tickSec / TimeInterval(arrayCount))
        let upAnimation = SKAction.sequence([setTiny, moveUp, expand])
        
        let randMoveUpRowOne = SKAction.run({
            // Setup array to randomly move up hexagons - make an array of sequential numbers and consume one each randomly
            var tempArray = Array(0..<arrayCount)
            for index in 0..<arrayCount {
                let randEle = Int(arc4random_uniform(UInt32(tempArray.count)))
                let randNum = tempArray[randEle]
                tempArray.remove(at: randEle)
                
                let varWait = SKAction.wait(forDuration: (tickSec / TimeInterval(arrayCount)) * TimeInterval(index))
                let waitThenUp = SKAction.sequence([varWait, upAnimation])
                self.tileRowOne.children[randNum].run(waitThenUp)
            }
        })
        
        let randMoveUpRowTwo = SKAction.run({
            // Setup array to randomly move up hexagons - make an array of sequential numbers and consume one each randomly
            var tempArray = Array(0..<arrayCount)
            for index in 0..<arrayCount {
                let randEle = Int(arc4random_uniform(UInt32(tempArray.count)))
                let randNum = tempArray[randEle]
                tempArray.remove(at: randEle)
                
                let varWait = SKAction.wait(forDuration: (tickSec / TimeInterval(arrayCount)) * TimeInterval(index))
                let waitThenUp = SKAction.sequence([varWait, upAnimation])
                self.tileRowTwo.children[randNum].run(waitThenUp)
            }
        })
        
        // Setup Creep Up Loop
        let startWait = SKAction.wait(forDuration: startWaitSec)
        let tickWait = SKAction.wait(forDuration: tickSec)
        
        let creepLoop = SKAction.repeatForever(SKAction.sequence([randMoveUpRowOne, tickWait, randMoveUpRowTwo, tickWait]))
        let waitCreep = SKAction.sequence([startWait, creepLoop])
        
        let moveUpHalf = SKAction.moveBy(x: 0, y: hexTileSize.height / 2, duration: 0)
        let coverLoop = SKAction.repeatForever(SKAction.sequence([tickWait, moveUpHalf]))
        let waitCover = SKAction.sequence([startWait, coverLoop])
        
        creepNode.run(waitCreep)
        coverSpriteNode.run(waitCover)
    }
}