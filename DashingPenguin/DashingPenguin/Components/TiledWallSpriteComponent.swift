//
//  SpriteComponent.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class TiledWallSpriteComponent: GKComponent {
    
    let node: SKNode
    var textureFrames = [SKTexture]()
    var TileSprites = [SKSpriteNode]()
    
    // Init with Texture Atlas Frames
    init(textureFrames: [SKTexture], tileNum: Int) {
        // Texture and parent node setup
        for texture in textureFrames {
            texture.filteringMode = SKTextureFilteringMode.nearest
        }
        self.textureFrames = textureFrames
        node = SKNode()
        
        // Caculate leftmost tile position
        let tileSize = textureFrames[0].size()
        let isEven: Bool = (tileNum % 2 == 0)
        let midPointOfLeftMostTile: CGFloat
        if isEven == true {
            midPointOfLeftMostTile = ( ( -CGFloat(tileNum) / 2 ) * tileSize.width ) + tileSize.width / 2
        } else {
            midPointOfLeftMostTile = ( -CGFloat(tileNum - 1) / 2 ) * tileSize.width
        }
        
        // Lay tiles
        for index in 0..<tileNum {
            let spriteNode = SKSpriteNode(texture: textureFrames[0], color: SKColor.clear, size: tileSize)
            let xPos = midPointOfLeftMostTile + (CGFloat(index) * tileSize.width)
            spriteNode.position = CGPoint(x: xPos, y:0)
            node.addChild(spriteNode)
        }
        
        super.init()
    }
    
    // Init as Rectangle for Debug
    init(color: UIColor, size: CGSize) {
        node = SKSpriteNode(color: color, size: size)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print(aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
