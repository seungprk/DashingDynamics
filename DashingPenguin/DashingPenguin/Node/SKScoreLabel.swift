//
//  SKScoreLabel.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 3/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit

class SKScoreLabel: SKNode {
    
    var numberFont = [SKTexture]()
    
    override init() {
        super.init()
        initNumberFont()
        let test = SKSpriteNode(texture: numberFont.first)
        self.addChild(test)
    }
    
    private func initNumberFont() {
        let atlas = SKTextureAtlas(named: "number-font")
        atlas.textureNames.forEach { name in
            let texture = atlas.textureNamed(name)
            texture.filteringMode = .nearest
            numberFont.append(texture)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

