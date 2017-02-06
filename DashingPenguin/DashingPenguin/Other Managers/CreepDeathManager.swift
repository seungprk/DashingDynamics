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
        tileRowOne.position.y = -scene.size.height / 2
        tileRowTwo.position.y = tileRowOne.position.y + hexTileSize.height / 2
        
        // Add Nodes
        scene.addChild(creepNode)
        creepNode.addChild(tileRowOne)
        creepNode.addChild(tileRowTwo)
        creepNode.addChild(coverSpriteNode)
        restartAnimateRows()
    }
    
    func updatePhysicsBodyPos(cameraYPos: CGFloat) {
        let topOfContactNode = (hexTileSize.height / 2) + (tileRowTwo.position.y > tileRowOne.position.y ? tileRowTwo.position.y : tileRowOne.position.y)
        let botOfCamera = cameraYPos - scene.size.height / 2
        if topOfContactNode + 1 < botOfCamera { // +1 to cover for float inaccuracies
            restartAnimateRows()
        }
        print("Top of Contact: ", topOfContactNode, " Bot of Cam: ", botOfCamera)
    }
    
    func restartAnimateRows() {
        // Clear Actions
        tileRowOne.removeAllActions()
        tileRowTwo.removeAllActions()
        coverSpriteNode.removeAllActions()
        
        // Reset Pos
        tileRowTwo.position.y = (scene.cameraNode?.position.y)! - (scene.size.height / 2) - (hexTileSize.height / 2)
        tileRowOne.position.y = tileRowTwo.position.y - hexTileSize.height / 2
        coverSpriteNode.position.y = tileRowTwo.position.y - coverSpriteNode.size.height / 2
        
        // Reapply actions
        let tickSec: TimeInterval = 1
        let startWaitSec: TimeInterval = 1
        
        let moveUp = SKAction.moveBy(x: 0, y: hexTileSize.height, duration: 0)
        let wait = SKAction.wait(forDuration: tickSec * 2)
        let startWait = SKAction.wait(forDuration: startWaitSec)
        let moveUpSeq = SKAction.sequence([moveUp, wait])
        let moveUpLoop = SKAction.repeatForever(moveUpSeq)
        let waitThenLoop = SKAction.sequence([startWait, moveUpLoop])
        
        let waitHalf = SKAction.wait(forDuration: tickSec)
        let waitHalfThenLoop = SKAction.sequence([startWait, waitHalf, moveUpLoop])
        
        let moveUpHalf = SKAction.moveBy(x: 0, y: hexTileSize.height / 2, duration: 0)
        let moveUpHalfPerTickSeq = SKAction.sequence([moveUpHalf, waitHalf])
        let moveUpHalfPerTickLoop = SKAction.repeatForever(moveUpHalfPerTickSeq)
        let waitThenMoveHalfPerTickLoop = SKAction.sequence([startWait, moveUpHalfPerTickLoop])
        
        tileRowOne.run(waitThenLoop)
        tileRowTwo.run(waitHalfThenLoop)
        coverSpriteNode.run(waitThenMoveHalfPerTickLoop)
    }
}
