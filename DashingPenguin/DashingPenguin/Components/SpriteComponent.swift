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
    
    // Init with Texture
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: SKColor.clear(), size: texture.size())
        
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
