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
        let wallYPos =  dashDistPlusPlatHeight - wallThickness/2 - (playerSprite?.size.height)!/2
        
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
        size = CGSize(width: scene.size.width, height: maxDash + platformSize.height)
        
        // Setup Next Block's Platform X Position
        let rMax = maxDash
        let rMin = platformSize.width
        var randXShift = rMin + CGFloat(arc4random_uniform(UInt32(rMax-rMin)) + 1)
        
        let maxShift = scene.size.width/2 - platformSize.width/2
        if randXShift > maxShift {
            randXShift = maxShift
        }
        
        if wallOnLeft == true {
            nextBlockFirstPlatformXPos = firstPlatXPos - randXShift
        } else {
            nextBlockFirstPlatformXPos = firstPlatXPos + randXShift
        }
        
        // Background for debug
        //addChild(SKSpriteNode(color: UIColor.purple, size: self.size))
        //addChild(SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width - 5, height: self.size.height - 5)))
        
        // Setup Platform
        let firstPlatform = Platform()
        let firstPlatformSpriteNode = firstPlatform.component(ofType: SpriteComponent.self)!.node
        firstPlatformSpriteNode.position = CGPoint(x: firstPlatXPos, y: -size.height/2 - firstPlatformSpriteNode.size.height/2 + GameplayConfiguration.Platform.size.height)
        addChild(firstPlatformSpriteNode)
        platforms.append(firstPlatform)

        // Setup Obstacle Wall
        obstacleWall = ObstacleWall(size: CGSize(width: wallLength, height: wallThickness), textures: [SKTexture(imageNamed: "obstaclewall")])
        let obstacleSpriteNode = obstacleWall.component(ofType: TiledWallSpriteComponent.self)!.node
        obstacleSpriteNode.position = CGPoint(x: wallXPos, y: -size.height/2 + wallYPos)
        obstacleSpriteNode.zPosition = firstPlatformSpriteNode.zPosition
        addChild(obstacleSpriteNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
