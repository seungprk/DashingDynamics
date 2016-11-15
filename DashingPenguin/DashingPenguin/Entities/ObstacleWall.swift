//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleWall: GKEntity {
    
    var size: CGSize!
    
    init(size: CGSize, textures: [SKTexture]) {
        super.init()
        
        // Modify input size's width to be a multiple of the tile width
        let widthOfTile = SKTexture(imageNamed: "obstaclewall").size().width
        let tileMultiple = Int(size.width) / Int(widthOfTile)
        let inputSizeIsTileMultiple:Bool = ( Int(size.width) == tileMultiple )
        var resultingTileNum: Int
        if inputSizeIsTileMultiple {
            self.size = size
            resultingTileNum = tileMultiple
        } else {
            self.size = CGSize(width: CGFloat(tileMultiple+1) * widthOfTile, height: size.height)
            resultingTileNum = tileMultiple + 1
        }
        
        let spriteComponent = TiledWallSpriteComponent(textureFrames: textures, tileNum: resultingTileNum)
        
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.collisionBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.none
        spriteComponent.node.physicsBody = physicsBody
        
        addComponent(spriteComponent)
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
