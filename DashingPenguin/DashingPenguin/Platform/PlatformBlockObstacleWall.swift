//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlockObstacleWall: PlatformBlock {
    
    var obstacleWall: ObstacleWall!
    
    init(scene: GameScene, firstPlatXPos: CGFloat) {
        super.init()
        
        let platformSize = Platform().size
        let wallThickness: CGFloat = 10
        let wallOnLeft: Bool!
        
        // Pick left wall or right wall
        if firstPlatXPos > 0 {
            wallOnLeft = true
        } else {
            wallOnLeft = false
        }
        
        // Y Position of Wall
        let maxDash = GameplayConfiguration.TouchControls.maxDistance
        let playerSprite = scene.player?.component(ofType: SpriteComponent.self)?.node
        let dashDistPlusPlatHeight = platformSize.height/2 + maxDash
        let wallYPos =  dashDistPlusPlatHeight - wallThickness/2 - (playerSprite?.size.height)!
        
        // X Position of Wall
        var wallLeftX: CGFloat!
        var wallRightX: CGFloat!
        if wallOnLeft == true {
            wallLeftX = -scene.size.width/2
            wallRightX = firstPlatXPos - platformSize.width/2
        } else {
            wallLeftX = firstPlatXPos + platformSize.width/2
            wallRightX = scene.size.width/2
        }
        let wallXPos = (wallLeftX + wallRightX)/2
        
        // Wall Length
        let wallLength = wallRightX - wallLeftX
        
        // Setup Next Block's Platform Y Position through Size
        size = CGSize(width: scene.size.width, height: maxDash)
        
        // Setup Next Block's Platform X Position
        let maxShiftFromCenter = scene.size.width / 2 - GameplayConfiguration.Platform.size.width / 2 - GameplayConfiguration.Sidewall.width// to not overlap with side walls
        
        if wallOnLeft == true {
            nextBlockFirstPlatformXPos = firstPlatXPos - maxDash
            if nextBlockFirstPlatformXPos < -maxShiftFromCenter {
                nextBlockFirstPlatformXPos = -maxShiftFromCenter
            }
        } else {
            nextBlockFirstPlatformXPos = firstPlatXPos + maxDash
            if nextBlockFirstPlatformXPos > maxShiftFromCenter {
                nextBlockFirstPlatformXPos = maxShiftFromCenter
            }
        }
        
        // Background for debug
        //addChild(SKSpriteNode(color: UIColor.purple, size: self.size))
        //addChild(SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platform
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.component(ofType: SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos, y: -size.height/2 - firstPlatformSpriteNode.size.height/2 + GameplayConfiguration.Platform.size.height)
        addChild(firstPlatformSpriteNode)
        entities.append(firstPlatform)
        
        // Setup Obstacle Wall
        
        obstacleWall = ObstacleWall(size: CGSize(width: wallLength, height: wallThickness))
        let obstacleSpriteNode = obstacleWall.component(ofType: TiledWallSpriteComponent.self)!.node
        obstacleSpriteNode.position = CGPoint(x: wallXPos, y: -size.height/2 + wallYPos)
        
        addChild(obstacleSpriteNode)
        entities.append(obstacleWall)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
