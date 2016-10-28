//
//  SpriteComponent.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    var textureFrames = [SKTexture]()
    
    // Init with Texture
    init(texture: SKTexture) {
        texture.filteringMode = SKTextureFilteringMode.nearest
        node = SKSpriteNode(texture: texture, color: SKColor.clear, size: texture.size())
        super.init()
    }
    
    // Init with Texture Atlas Frames
    init(textureFrames: [SKTexture]) {
        for texture in textureFrames {
            texture.filteringMode = SKTextureFilteringMode.nearest
        }
        self.textureFrames = textureFrames
        node = SKSpriteNode(texture: textureFrames[0], color: SKColor.clear, size: textureFrames[0].size())
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
