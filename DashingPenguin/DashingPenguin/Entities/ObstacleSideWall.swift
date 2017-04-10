//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleSideWall: GKEntity {
    
    var size: CGSize!
    var tiles = [SKSpriteNode]()
    var tileSize = SKTexture(imageNamed: "wall").size()
    var cameraTopY: CGFloat = 0
    init(size: CGSize) {
        super.init()
        self.size = size
    }
    
    func tileSideWall(scene: GameScene) {
        let currentCameraTopY = (scene.cameraNode?.position.y)! + scene.size.height / 2
        if currentCameraTopY > cameraTopY {
            cameraTopY = (scene.cameraNode?.position.y)! + scene.size.height / 2
        }
        var topTileY: CGFloat
        // Start tiling from a screen below position 0
        topTileY = tiles.count == 0 ? -scene.size.height : (tiles.last?.position.y)! + tileSize.height / 2
        var tileNum = 0
        let adjustedCameraTopY = cameraTopY + 100
        
        // Add tiles
        if adjustedCameraTopY > topTileY {
            tileNum = Int((adjustedCameraTopY - topTileY) / tileSize.height) + 20 // 20 tiles added for batch loading
            
            for index in 0..<tileNum {
                // Right tile
                var randInt = arc4random_uniform(4)
                var randTexture: SKTexture
                if randInt == 0 {
                    randTexture = SKTexture(imageNamed: "wallb")
                } else {
                    randTexture = SKTexture(imageNamed: "wall")
                }
                randTexture.filteringMode = .nearest
                let newWallRight = SKSpriteNode(texture: randTexture)
                let xPos = size.width / 2 - GameplayConfiguration.Sidewall.width / 2
                let yPos = topTileY + tileSize.height / 2 + tileSize.height * CGFloat(index)
                let position = CGPoint(x: xPos, y: yPos)
                newWallRight.position = position
                newWallRight.zPosition = 10
                newWallRight.xScale = -1
                newWallRight.physicsBody = nil
                scene.sceneEffectNode.addChild(newWallRight)
                tiles.append(newWallRight)
                
                // Left tile
                randInt = arc4random_uniform(4)
                if randInt == 0 {
                    randTexture = SKTexture(imageNamed: "wallb")
                } else {
                    randTexture = SKTexture(imageNamed: "wall")
                }
                randTexture.filteringMode = .nearest
                let newWallLeft = SKSpriteNode(texture: randTexture)
                newWallLeft.position = CGPoint(x: -size.width / 2 + GameplayConfiguration.Sidewall.width / 2, y: yPos)
                newWallLeft.zPosition = 10
                newWallLeft.physicsBody = nil
                scene.sceneEffectNode.addChild(newWallLeft)
                tiles.append(newWallLeft)
            }
            
            // Remove tiles half a screen below
            let removeDistanceY = (scene.cameraNode?.position.y)! - (tiles.first?.position.y)! - scene.size.height
            if removeDistanceY > 0 {
                let removeNum = Int((removeDistanceY / tileSize.height) * 2)
                for index in 0..<removeNum {
                    tiles[index].removeFromParent()
                }
                print("***REMOVE", removeNum, "From", tiles[0].position, " to" , tiles[removeNum-1].position)
                tiles.removeFirst(removeNum)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
