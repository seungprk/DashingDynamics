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
    
    var scene: GameScene!
    var tiles = [SKSpriteNode]()
    var tileSize = SKTexture(imageNamed: "wall").size()
    var cameraTopY: CGFloat = 0
    var coverSprite: SKSpriteNode!
    var magnetAnimatedTextureFrames: [SKTexture]!
    
    init(scene: GameScene) {
        super.init()
        self.scene = scene
        
        // Setup Magnet Textures
        let magnetAnimatedAtlas = SKTextureAtlas(named: "magnetwall")
        magnetAnimatedTextureFrames = [SKTexture]()
        for count in 1...magnetAnimatedAtlas.textureNames.count {
            let texture = magnetAnimatedAtlas.textureNamed("magnetwall" + String(count))
            magnetAnimatedTextureFrames.append(texture)
        }
        for texture in magnetAnimatedTextureFrames {
            texture.filteringMode = .nearest
        }
        
        let xPos = scene.size.width / 2 - GameplayConfiguration.Sidewall.width / 2
        coverSprite = SKSpriteNode(texture: magnetAnimatedTextureFrames[0])
        coverSprite.position = CGPoint(x: xPos, y: 0)
        coverSprite.size.height = scene.size.height
        coverSprite.zPosition = 11
        coverSprite.alpha = 0.0
        
        scene.sceneCamEffectNode.addChild(coverSprite)
    }
    
    func tileSideWall() {
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
                let xPos = scene.size.width / 2 - GameplayConfiguration.Sidewall.width / 2
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
                newWallLeft.position = CGPoint(x: -scene.size.width / 2 + GameplayConfiguration.Sidewall.width / 2, y: yPos)
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
    
    func animateMagnet() {
        let fadeIn = SKAction.fadeAlpha(to: 0.9, duration: 1.0)
        let animateMagnet = SKAction.animate(with: magnetAnimatedTextureFrames, timePerFrame: 0.03)
        let repeatAnimateMagnet = SKAction.repeatForever(animateMagnet)
        coverSprite.run(fadeIn)
        coverSprite.run(repeatAnimateMagnet, withKey: "repeatAnimateMagnet")
    }
    
    func removeMagnetAnimation() {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        coverSprite?.run(fadeOut, completion: {
            self.coverSprite.removeAction(forKey: "repeatAnimateMagnet")
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
